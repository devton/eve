// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//$(function() {
document.addEventListener("turbolinks:load", function() {
    $('.chart-data').each(function(i, item) {
        var activity = $(item).data('activity'),
            chartId = '#' + $(item).prop('id'),
            colors = d3.scale.category20(),
            color = d3.scale.ordinal()
                .domain(['new_events', 'click', 'delivered', 'open', 'droped', 'spamreport'])
                .range(['#B3E5FC', '#81D4FA', '#4FC3F7', '#80DEEA', '#FFB300', '#BF360C']),
            chart;

        nv.addGraph(function() {
            var chart = nv.models.multiBarChart()
            //var chart = nv.models.stackedAreaChart()
                    .x(function(d) { return d[0] })
                    .y(function(d) { return d[1] })
                    .clipEdge(true)
                    .useInteractiveGuideline(true)
                    .showControls(false)
                 		.showYAxis(false)
                    .width(650)
                    //.margin({left: -100})
//                 		.stream(true)
                    //.style('stream')
                    .stacked(true)
                    .showLegend(false)
            ;

           chart.color(d3.scale.category20b().range());

            //chart.barColor(function (d, i) {
            //    var colors = d3.scale.category20();
            //    return color.range()[i % colors.length-1];
            //});

            //chart.color(function (d, i) {
            //    var colors = d3.scale.category20();
            //    return color.range()[i % colors.length-1];
            //});

            chart.xAxis
                .showMaxMin(false)
                .tickFormat(function(d) {
                    d2 = new Date(0);
                    d2.setUTCSeconds(d);
                    return d3.time.format('%H:%M')(d2);
                });

            chart.yAxis
                .tickFormat(d3.format());

            d3.select(chartId)
                .datum(activity)
                .transition().duration(500).call(chart);

            nv.utils.windowResize(chart.update);

            return chart;
        });
    });
});
