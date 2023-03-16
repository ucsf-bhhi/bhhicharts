Highcharts.theme = {
  colors: ["#0668b3", "#00b0bd", "#00b14c", "#f47722", "#ffc709", "#e60088", "#821a56", "#6c62d0"],
  credits: {
    enabled: false,
    text: ""
  },
  chart: {
    style: {
      fontFamily: "Helvetica, sans-serif"
    },
    xAxis: {
      lineColor: "#c7cfda",
      gridLineColor: "#c7cfda"
    },
    events: {
      render: function () {
        const chart = this;
        /* highcharts needs an absolute path for export. chart pages are all in
        site root, so match everything before the last "/" in the url then
        append the relative path to the logo*/
        const imageSource = location.href.match(".*\/")[0] + 'img/bhhi_logo_lean.png';
        const imageWidth = 796;
        const imageHeight = 169;

        if (!chart.logo) chart.logo = chart.renderer.image(imageSource).add();

        const maxLogoWidth = chart.plotWidth * 0.4;

        let logoWidth = Math.min(191, maxLogoWidth);
        let logoHeight = imageHeight * (logoWidth / imageWidth);

        let logoX, logoY;

        const logoBottomPadding = 5;

        if (chart.axes.length === 2) {
          const bottomAxisIndex = chart.inverted ? 1 : 0;

          const bottomAxisBox = chart.axes[bottomAxisIndex].labelGroup.getBBox();

          const bottomAxisBottom = bottomAxisBox['y'] + bottomAxisBox['height'] + logoBottomPadding;

          const maxLogoHeight = chart.chartHeight - bottomAxisBottom - logoBottomPadding;

          const heightPct = maxLogoHeight / logoHeight;
          const widthPct = maxLogoWidth / logoWidth;

          const minScaleFactor = Math.min(heightPct, widthPct);

          if (minScaleFactor < 1) {
            logoHeight = logoHeight * minScaleFactor;
            logoWidth = logoWidth * minScaleFactor;
          }

          if (logoHeight < maxLogoHeight) {
            logoY = chart.chartHeight - maxLogoHeight * 0.5 - logoHeight * 0.5;
          }
          else {
            logoY = chart.chartHeight - logoHeight - logoBottomPadding;
          }
        }
        else {
          logoY = chart.chartHeight - logoHeight - logoBottomPadding;
        }
        logoX = chart.plotLeft + chart.plotWidth - logoWidth;

        chart.logo.attr({
          x: logoX,
          y: logoY,
          width: logoWidth,
          height: logoHeight
        });
      }
    }
  }
}

Highcharts.setOptions(Highcharts.theme);