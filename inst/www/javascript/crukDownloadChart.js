// Download a plotly chart as PNG with a heading, using html2canvas.
// Requires html2canvas.min.js (MIT) to be loaded first (see crukDownloadChartButton()).
// Uses event delegation, so buttons added later via renderUI()/modals work.
(function () {
  "use strict";

  function safeFilename(name) {
    var cleaned = String(name || "chart").replace(/[^A-Za-z0-9._-]+/g, "-");
    // Trim leading/trailing dashes with a loop rather than a regex: /-+$/ backtracks badly
    var start = 0;
    var end = cleaned.length;
    while (start < end && cleaned[start] === "-") start++;
    while (end > start && cleaned[end - 1] === "-") end--;
    cleaned = cleaned.slice(start, end);
    return (cleaned || "chart") + ".png";
  }

  function textFromId(id) {
    if (!id) return "";
    var el = document.getElementById(id);
    return el ? el.textContent.trim() : "";
  }

  function headingText(btn) {
    var fixed = btn.getAttribute("data-heading");
    if (fixed) return fixed;
    return textFromId(btn.getAttribute("data-heading-id"));
  }

  function subheadingText(btn) {
    var fixed = btn.getAttribute("data-subheading");
    if (fixed) return fixed;
    return textFromId(btn.getAttribute("data-subheading-id"));
  }

  function download(canvas, filename) {
    return new Promise(function (resolve, reject) {
      canvas.toBlob(function (blob) {
        if (!blob) { reject(new Error("Canvas could not be converted to PNG")); return; }
        var url = URL.createObjectURL(blob);
        var a = document.createElement("a");
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
        resolve();
      }, "image/png");
    });
  }

  async function capture(btn) {
    var plotId = btn.getAttribute("data-plot-id");
    var plot = document.getElementById(plotId);
    if (!plot?.querySelector(".main-svg")) {
      console.error("crukDownloadChartButton: no rendered plotly chart found with id '" + plotId + "'");
      return;
    }
    if (typeof html2canvas !== "function") {
      console.error("crukDownloadChartButton: html2canvas is not loaded");
      return;
    }

    var scale = parseFloat(btn.getAttribute("data-scale")) || 2;
    var width = plot.getBoundingClientRect().width;

    // Off-screen wrapper: heading + a static copy of the chart.
    // Placed behind the page (z-index) at the top left rather than far off-screen,
    // because html2canvas can mis-render elements positioned outside the viewport.
    var wrap = document.createElement("div");
    wrap.style.cssText =
      "position:fixed;top:0;left:0;z-index:-9999;pointer-events:none;" +
      "background:#ffffff;padding:16px;box-sizing:content-box;width:" + width + "px;" +
      "font-family:" + getComputedStyle(plot).fontFamily + ";";

    var text = headingText(btn);
    var subtext = subheadingText(btn);
    if (text) {
      var h = document.createElement("h3");
      h.textContent = text;
      h.style.cssText = "margin:0 0 " + (subtext ? "4px" : "12px") +
        " 0;padding:0;font-weight:700;line-height:1.25;color:#2e2f3b;";
      wrap.appendChild(h);
    }
    if (subtext) {
      var s = document.createElement("h4");
      s.textContent = subtext;
      s.style.cssText = "margin:0 0 12px 0;padding:0;font-size:1rem;font-weight:400;line-height:1.35;color:#2e2f3b;";
      wrap.appendChild(s);
    }

    var copy = plot.cloneNode(true);
    copy.removeAttribute("id");                       // avoid a duplicate id on the page
    copy.style.width = width + "px";
    copy.querySelectorAll(".modebar-container").forEach(function (m) { m.remove(); });
    wrap.appendChild(copy);
    document.body.appendChild(wrap);

    btn.disabled = true;
    try {
      var canvas = await html2canvas(wrap, {
        backgroundColor: "#ffffff",
        scale: scale,
        useCORS: true,
        logging: false,
        scrollX: 0,
        scrollY: 0
      });
      await download(canvas, safeFilename(btn.getAttribute("data-filename")));
    } catch (err) {
      console.error("crukDownloadChartButton: snapshot failed", err);
    } finally {
      document.body.removeChild(wrap);
      btn.disabled = false;
    }
  }

  document.addEventListener("click", function (e) {
    var btn = e.target.closest?.(".cruk-download-chart");
    if (!btn || btn.disabled) return;
    e.preventDefault();
    capture(btn).catch(function (err) {
      console.error("crukDownloadChartButton: unexpected error", err);
    });
  });
})();
