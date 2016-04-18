// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//$(function() {
document.addEventListener("turbolinks:load", function() {
    $('#event_trigger_search').search({
        source: $('#event_trigger_search').data('evnames')
    });
    $('.chart-data').each(function(i, item) {
        var activity = $(item).data('activity'),
            chartId = '#' + $(item).prop('id'),
            chart;

        nv.addGraph(function() {
            var chart = nv.models.stackedAreaChart()
                    .x(function(d) { return d[0] })
                    .y(function(d) { return d[1] })
                    .clipEdge(true)
                    .useInteractiveGuideline(true)
                    .showControls(false)
                    .showYAxis(false)
                    .width(650)
                    .height(170)
                    .showLegend(false)
            ;

            chart.color(d3.scale.category20b().range());

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
