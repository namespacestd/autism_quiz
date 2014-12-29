
var casper = require('casper').create({
    clientScripts: ["./jquery-1.11.2.js"]
});
var utils = require('utils');
var result = null;

var results = {};
var youtube_url = casper.cli.get("url");

casper.start("http://www.youtube-mp3.org/", function() {
    result = this.evaluate(function(url) {
        $("#youtube-url").val(url);
        $("input[type='submit']").submit();
    }, youtube_url);

    function waitFor ($config) {
        $config._start = $config._start || new Date();

        if ($config.timeout && new Date - $config._start > $config.timeout) {
            if ($config.error) $config.error();
            return;
        }

        if ($config.check()) {
            return $config.success();
        }

        setTimeout(waitFor, $config.interval || 0, $config);
    }

    waitFor({
        debug: true,  // optional
        interval: 0,  // optional
        timeout: 5000,  // optional
        check: function () {
            return casper.evaluate(function() {
                return ($('#dl_link').children().length > 1);
            });
        },
        success: function () {
            var dl_link = casper.evaluate(function() {
                return $('#dl_link a:visible')[0].href;
            });
            casper.echo(dl_link);
        },
        error: function () {} // optional
    });
});

casper.run();