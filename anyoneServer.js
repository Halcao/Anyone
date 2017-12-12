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
    var items = list.replace('\\n', '')
                .replace('\n', '')
                .split('$')
                .filter( str => str.length >= 17)
                .map(str => str.split(' '))
                .map(arr => ({mac: arr[1], ip: arr[2], defaultName: arr[3]}));
    var macData = items.map(e => e.mac);
    var newDate = new Date();
    newDate.setTime(req.body.date * 1000);

    connection.query("SELECT mac FROM user", function(err, result) {
        if (err) {
            console.log('[SELECT ERROR] - ',err.message);
            var response = {
                "err_code": err.code,
                "msg": err.message,
            }
            //connection.end();    
            res.send(JSON.stringify(response));
            return;
        }
        var userList = result.map(e => e.mac);
        var newUsers = items.filter(function(e) {
            return userList.indexOf(e.mac) < 0;
        });
        var formatedDate = (new Date ((new Date((new Date(new Date())).toISOString() )).getTime() - ((new Date()).getTimezoneOffset()*60000))).toISOString().slice(0, 19).replace('T', ' ');        
        for (var user of newUsers) {
            connection.query(`INSERT INTO user(id, name, mac, default_name, insert_at) VALUES (0, '${user.defaultName}', '${user.mac}', '${user.defaultName}', '${formatedDate}')`, function(err, result) {
                if (err) {
                    console.log('[SELECT ERROR] - ',err.message);
                    var response = {
                        "err_code": err.code,
                        "msg": err.message,
                    }
                    //connection.end();    
                    res.send(JSON.stringify(response));
                    return;
                }
                connection.query(`INSERT INTO status(id, is_present, ip, update_at) VALUES (${result.insertId}, 0, '${user.ip}', '${formatedDate}')`);
                connection.query(`INSERT INTO stat(id, week_time, total_time, update_at) VALUES (${result.insertId}, 0, 0, '${formatedDate}')`);
            });

            // connection.query("");
        }
    });

    connection.query("SELECT s.id, u.mac, s.is_present FROM status AS s INNER JOIN user AS u ON u.id = s.id", function(err, result) {
        if (err) {
            console.log('[SELECT ERROR] - ',err.message);
            var response = {
                "err_code": err.code,
                "msg": err.message,
            }
            //connection.end();    
            res.send(JSON.stringify(response));
            return;
        }
        
        // 在线用户
        var allPresentMembers = result.filter(e => macData.indexOf(e.mac) >= 0).map(e => e.id);
        // 上次在线用户
        var lastPresentMembers = result.filter(e => e.is_present == 1).map(e => e.id)

        // 新来的用户 allPresentMembers - lastPresentMembers
        var newComers = allPresentMembers.filter(function(id) {
            return lastPresentMembers.indexOf(id) < 0;
        });
        // 刚走的用户 lastPresentMembers - allPresentMembers
        var newLeavers = lastPresentMembers.filter(function(id) {
            return allPresentMembers.indexOf(id) < 0;
        });

        for (var id of newComers) {
            var formatedDate = (new Date ((new Date((new Date(new Date())).toISOString() )).getTime() - ((new Date()).getTimezoneOffset()*60000))).toISOString().slice(0, 19).replace('T', ' ');
            connection.query(`UPDATE status SET is_present = true, update_at = '${formatedDate}' WHERE id = ${id}`);
            connection.query(`INSERT INTO log VALUES (0, ?, ?, ?)`, [id, "enter", formatedDate]);
            // connection.query(`INSERT INTO log(id, action, time) VALUES (0, ?, ?, ?)`, [id, "enter", formatedDate]);
        }

        for (var id of newLeavers) {
            var formatedDate = (new Date ((new Date((new Date(new Date())).toISOString() )).getTime() - ((new Date()).getTimezoneOffset()*60000))).toISOString().slice(0, 19).replace('T', ' ');
            connection.query(`UPDATE status SET is_present = false, update_at = '${formatedDate}' WHERE id = ${id}`);
            connection.query(`INSERT INTO log VALUES (0, ?, ?, ?)`, [id, "leave", formatedDate]);
            // connection.query(`INSERT INTO log(id, action, time) VALUES (?, ?, ?)`, [id, "leave", formatedDate]);
        }

        // for (var id of allPresentMembers) {
        //     var formatedDate = (new Date ((new Date((new Date(new Date())).toISOString() )).getTime() - ((new Date()).getTimezoneOffset()*60000))).toISOString().slice(0, 19).replace('T', ' ');
        //     connection.query(`UPDATE SET total_time = total_time + 1, week_time = week_time + 1, update_at = ${formatedDate} FROM stat WHERE id = ?`, [id]);
        //     var ip = items
        //     connection.query(`UPDATE SET ip = ? FROM status`, []);
        // }
        for (var item of items) {
            var formatedDate = (new Date ((new Date((new Date(new Date())).toISOString() )).getTime() - ((new Date()).getTimezoneOffset()*60000))).toISOString().slice(0, 19).replace('T', ' ');
            var array = result.filter(e => e.mac === item.mac);
            if (array.length == 1) {
                var id = array[0].id;
                connection.query(`UPDATE stat SET total_time = total_time + 1, week_time = week_time + 1, update_at = '${formatedDate}' WHERE id = ${id}`);
                connection.query(`UPDATE status SET ip = '${item.ip}' WHERE id = ${id}`);    
            }
        }

            // 响应
        var response = {
            "err_code": 0,
            "date": newDate.toLocaleString(),
            "msg": "ok"
        }
        //connection.end();    
        res.send(JSON.stringify(response));
    })
});

app.get('/getPresent', function(req, res) {
    connection.query('SELECT DISTINCT u.name FROM status AS s INNER JOIN user AS u WHERE s.is_present = true', function(err, result) {
        if (err) {
            console.log('[SELECT ERROR] - ',err.message);
            var response = {
                "err_code": err.code,
                "msg": err.message,
            }
            //connection.end();    
            res.send(JSON.stringify(response));
            return;
        }
        var newDate = new Date();    
        var names = {"list": result, "date": newDate.toLocaleString()};
        res.send(JSON.stringify(names))
    });
});

var server = app.listen(8080, function() {
    var host = server.address().address;
    var port = server.address().port;
    console.log(`server started at ${host}:${port}`)
});
