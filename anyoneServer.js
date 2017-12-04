'use strict';

var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var connection = require('./config.js');

connection.connect();


// id, name, mac, is_present, week_time, total_time, master_id

// 创建 application/x-www-form-urlencoded 编码解析
var urlencodedParser = bodyParser.urlencoded({ extended: false })

app.post('/update', urlencodedParser, function(req, res) {
    console.log(req.body);
    var list = req.body.list;
    // 每一行至少得有17位的 MAC 地址吧
    var items = list.split('\\n')
                .filter( str => str.length >= 17)
                .map(str => str.split(' '))
                .map(arr => ({mac: arr[1], ip: arr[2], name: arr[3]}));
    
    //connection.connect();
    connection.query("UPDATE user SET is_present = 0");    
    for (var item of items) {
        connection.query("UPDATE user SET is_present = 1 WHERE mac = ?", [item.mac]);
    }
    var response = {
        "err_code": 0,
        "msg": "ok"
    }
    //connection.end();    
    res.send(JSON.stringify(response));
});

app.get('/getPresent', function(req, res) {
    connection.query('SELECT name FROM user WHERE is_present = true', function(err, result) {
        if (err) {
            console.log('[SELECT ERROR] - ',err.message);
            return;
        }
        var names = {list: result.map(item => item.name)};
        res.send(JSON.stringify(names))
    });
});

var server = app.listen(8080, function() {
    var host = server.address().address;
    var port = server.address().port;
    console.log(`server started at ${host}:${port}`)
});
