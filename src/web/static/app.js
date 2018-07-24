// Author: Ryan Aviles

var timeFormat = 'MM/DD/YYYY HH:mm';
AWS.config.region = 'us-east-1';
AWS.config.credentials = new AWS.CognitoIdentityCredentials({IdentityPoolId: window.env.IDENTITY_POOL_ID})
var dynamodb = new AWS.DynamoDB({
    'region' : window.env.REGION
});

function queryAll(startDate, endDate) {

    var sensorPromise = getQueryPromise("TempHumiditySensor", startDate, endDate);
    var s3Promise     = getQueryPromise("S3Uploader", startDate, endDate);

    Promise.all([sensorPromise, s3Promise]).then(function(values){
        var sensorValues = values[0];
        var s3Values = values[1];
        var s3Images = [];

        if( sensorValues.$response.error || s3Values.$response.error) {
            console.log(sensorValues.$response.error, s3Values.$response.error)
            alert('An error occurred getting data'); // an error occurred
            return;
        }

        /*****************************************************************
         merge the s3 data with sensor data to get a single plotted list
        *****************************************************************/
        var merged = [];
        var sensorIndex = 0;
        var s3Index = 0;
        var current = 0;

        while( current < (sensorValues.Items.length + s3Values.Items.length)) {
            var sensorDate = sensorIndex < sensorValues.Items.length ? moment(sensorValues.Items[sensorIndex].created.S) : undefined;
            var s3Date     = s3Index < s3Values.Items.length ? moment(s3Values.Items[s3Index].created.S) : undefined;

            if( sensorDate && sensorDate.isBefore(s3Date)) {
                merged[current] = sensorValues.Items[sensorIndex];
                sensorIndex++
            }
            else if( s3Date ) {
                var item = s3Values.Items[s3Index];
                merged[current] = item;
                s3Index++;

                var img = new Image();
                img.src = item.url.S;
                $(img).attr('width','15px');
                $(img).attr('height','15px');

                s3Images.push(img);
            }

            current++;
        }

        for(var i in merged) {
            var item = merged[i];
            config.data.labels.push(moment(item.created.S).toDate());

            if( item.temperature ) {
                config.data.datasets[0].data.push(item.temperature.N);
                config.data.datasets[1].data.push(item.humidity.N);
            }
            else {
                config.data.datasets[0].data.push(undefined); // add the placeholder for the image data
            }
        }

        var ctx = document.getElementById("events_chart").getContext('2d');
        window.data_chart = new Chart(ctx, config );

        // add images
        var data = window.data_chart.config.data.datasets[0]._meta[0].data;
        var s3Cursor = 0;
        for( var x in data) {
            if( !data[x]._model.y) {
                var img = s3Images[s3Cursor++];
                $(img).attr('style', 'left:' + data[x]._model.x + 'px;top:' + window.data_chart.chartArea.bottom + 'px;position:absolute');
                $('body').append(img);
            }
        }
    });
}

function getQueryPromise(module_type, startDate, endDate) {

     var params = {
        TableName: window.env.DDB_EVENTS_TABLE,
        KeyConditionExpression: "module_type = :type",
        ExpressionAttributeValues: {
            ":type" : {
                S: module_type
            }
        }
     };

     if( startDate) {

        params.ExpressionAttributeValues[":d1"] = {
            S: startDate.toISOString()
        };

        params.ExpressionAttributeValues[":d2"] = {
            S: endDate.toISOString()
        }
        params['FilterExpression'] = ":d1 < created AND created < :d2";
     }

     return dynamodb.query(params).promise();
}

function getRandomColor() {
    var letters = '0123456789ABCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

var config = {
    type: 'line',
    data: {
        labels: [],
        datasets: [
            {
                label: 'Temperature(F)',
                borderColor: getRandomColor(),
                fill: false,
                data: []
            },
            {
                label: 'Humidity(%)',
                borderColor: getRandomColor(),
                fill: false,
                data: []
            }
        ]
    },
    options: {
        spanGaps: true,
        title: {
            text: 'Data Sets'
        },
        scales: {
            xAxes: [{
                type: 'time',
                distribution: 'series',
                ticks: {
                    source: 'labels',
                    maxRotation: 45,
                    minRotation: 45,
                    callback: function(value, index, values) {
                        return moment(values[index].value).format('MM/DD/YYYY hh:mm:ss');
                    }
                },
                time: {
                    format: timeFormat,
                    tooltipFormat: 'll HH:mm:ss',

                },
                scaleLabel: {
                    display: true,
                    labelString: 'Date'
                }
            }],
            yAxes: [{
                scaleLabel: {
                    display: true,
                    labelString: 'Value'
                },
                ticks: {
                    beginAtZero: true
                }
            }]
        }
    }
};

$( document ).ready(function() {

     $('input[name="dates"]').daterangepicker();
     $('input[name="dates"]').on('apply.daterangepicker', function(ev, picker) {
          $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
          queryAll(picker.startDate, picker.endDate);
     });

     queryAll();
});

