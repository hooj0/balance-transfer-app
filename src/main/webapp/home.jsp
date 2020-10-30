<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="ctxPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<title>区块链转账</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0,user-scalable=no" name="viewport" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	
	<link rel="stylesheet" href="${ctxPath}/res/css/core.css"/>
	<script type="text/javascript" src="${ctxPath}/res/jslib/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="${ctxPath}/res/jslib/json.js"></script>
	

	<script type="text/javascript">
		
		var SERVER_URL = "http://192.168.33.73:4000/";
		var $proxy = function (action, method, data, successCallback, errorCallback){
			$.ajax({
				url: "${pageContext.request.contextPath}/request?action=" + action,
				type: method,
				async: false,
	            data: data,
	            success: function(data) {
					if (data) {
						if (~data.indexOf("{")) {
							successCallback(eval("(" + data + ")"));
						} else {
							alert(data);
							errorCallback(data);
						}
					} else {
						alert("操作失败.");
					}
				},
				error: function(data) {
					if (~data.responseText.indexOf("<html>")) {
						alert("操作失败.");						
					} 
					errorCallback(data.responseText);
				}
			});
		};
		
		var login = function () { 	
			$.ajax({
				url: "${pageContext.request.contextPath}/request?action=users",
				type: "POST",
				async: false,
	            data: { "params": "username=" + $(".username").val() + "&orgName=" + $(".orgName").val() }, 
				success: function(data) {
					
					$(".token-data").text(data);
					
					if (data) {
						if (~data.indexOf("{")) {
							bindToken( eval("(" + data + ")") );
						} else {
							$(".token-data").text(data);
						}
					} else {
						alert("操作失败.");
					}
				},
				error: function(data) {
					
				
					if (~data.responseText.indexOf("<html>")) {
						alert("操作失败.");						
					} else {
						$(".token-data").text(data.responseText);
					}
				}
			});
		};
		
		var $request = function (action, method, data, successCallback, errorCallback, async) {
			
			if (async == "yes") {
				async = true;
			} else {
				async = false;
			}
			
			$.ajax({
				url: SERVER_URL + action,
				type: method,
				async: async,
	            data: data,
	            dataType: "text",
	            //contentType: "application/json",
	            headers: { "content-type": "application/json", "authorization": "Bearer " + $(".token:first").val() },
	            success: function(data) {
					if (data) {
						if (!~data.indexOf("<html")) {
							successCallback(data);
						} else {
							alert(data);
							errorCallback(data);
						}
					} else {
						alert("操作失败.");
					}
				},
				error: function(data) {
					if (~data.responseText.indexOf("<html>")) {
						alert("操作失败.");						
					} 
					errorCallback(data.responseText);
				}
			});
		};
		
		var $get = function (action, successCallback, errorCallback) {
			$request(action, "GET", null, successCallback, errorCallback, "yes");
		}
		
		var $post = function (action, data, successCallback, errorCallback) {
			$request(action, "POST", data, successCallback, errorCallback);
		}
		
		var register = function () { 	
			$.ajax({
				url: SERVER_URL + "users",
				type: "POST",
				async: false,
				dataType: "text",
				contentType: "application/x-www-form-urlencoded",
	            data: "username=" + $(".username").val() + "&orgName=" + $(".orgName").val(), 
				success: function(data) {
					
					$(".token-data").text(data);
					
					if (data) {
						if (~data.indexOf("{")) {
							bindToken( eval("(" + data + ")") );
						} else {
							$(".token-data").text(data);
						}
					} else {
						alert("操作失败.");
					}
				},
				error: function(data) {
					
					if (~data.responseText.indexOf("<html>")) {
						alert("操作失败.");						
					} else {
						$(".token-data").text(data.responseText);
					}
				}
			});
		};
		
		var bindToken = function (data) {
			
			if (data.success) {
				$(".token").val(data.token);
			} else {
				alert("注册失败")
			}
		}
		
		var queryAccount = function (acc) {
			$get("channels/mychannel/chaincodes/mycc?peer=peer0.org1.example.com&fcn=query&args=['" + acc + "']", function (data) {
				$("." + acc + "-account").text(data);
			}, function (data) {
				$("." + acc + "-account").text(data);
			}, true);
		}
		
		var queryCC = function () {
			$get("channels?peer=peer0.org1.example.com", function (data) {
				$(".channels").text(data);
			}, function (data) {
				$(".channels").text(data);
			});

			$get("channels/mychannel?peer=peer0.org1.example.com", function (data) {
				$(".channel-info").text(data);
			}, function (data) {
				$(".channel-info").text(data);
			});
			
			$get("chaincodes?peer=peer0.org1.example.com&type=installed", function (data) {
				$(".install-cc").text(data);
			}, function (data) {
				$(".install-cc").text(data);
			});
			
			$get("chaincodes?peer=peer0.org1.example.com&type=instantiated", function (data) {
				$(".instantiated-cc").text(data);
			}, function (data) {
				$(".instantiated-cc").text(data);
			});
		}
		
		$(function () {
			
			$(":reset").click(function () {
				$(this).parents("table").find(":text").val("");
			});
			
			$(".login:first").click(function () {
				//login();
				register();
			});
			
			$("select:first").change(function () {
				if ($(this).val() == "go") {
					$(".chaincodePath").val("github.com/example_cc/go");
					$(".chaincodeType").val("golang");
				} else {
					$(".chaincodePath").val("$PWD/artifacts/src/github.com/example_cc/node");
					$(".chaincodeType").val("node");
				}
			});
			
			window.setInterval(function () {
				
				if ($(":checkbox").attr("checked") == "checked") {
				} else {
					return;
				}
				
				if ($(".token").val()) {
					
					$get("chaincodes?peer=peer0.org1.example.com&type=instantiated", function (data) {
						queryCC();
					
						queryAccount("a");
						queryAccount("b");
					}, function (data) {
						console.log("查找数据异常：" + data);
					});
				}
				
			}, 3000);
			
			$(".create-account").click(function () {
				
				$table = $(this).parents("table");
				
				$post("channels", JSON.stringify({
					"channelName": $table.find(".channelName").val(),
					"channelConfigPath":"../artifacts/channel/mychannel.tx"
				}), function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				}, function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				});
				
				$post("channels/mychannel/peers", JSON.stringify({
					"peers": ["peer0.org1.example.com","peer1.org1.example.com"]
				}), function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				}, function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				});
				
				$post("chaincodes", JSON.stringify({
					"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
					"chaincodeName": $table.find(".chaincodeName").val(),
					"chaincodePath": $table.find(".chaincodePath").val(),
					"chaincodeType": $table.find(".chaincodeType").val(),
					"chaincodeVersion": $table.find(".chaincodeVersion").val()
				}), function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				}, function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				});
				
				$post("channels/mychannel/chaincodes", JSON.stringify({
					"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
					"chaincodeName": $table.find(".chaincodeName").val(),
					"chaincodePath": $table.find(".chaincodePath").val(),
					"chaincodeType": $table.find(".chaincodeType").val(),
					"chaincodeVersion": $table.find(".chaincodeVersion").val(),
					"args": [ "a", $table.find(".a").val(), "b", $table.find(".b").val() ]
				}), function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				}, function (data) {
					$table.find(".result").append("<p>" + data + "<p><hr/>");
				});
			});
			
			
			$(".invoke").click(function () {
				$table = $(this).parents("table");
				
				var args = [];
				if ($("select:last :selected").val() == "1") {
					args.push("a");
					args.push("b");
				} else {
					args.push("b");
					args.push("a");
				}
				args.push($(".money").val());
				
				$post("channels/mychannel/chaincodes/mycc", JSON.stringify({
					"peers": ["peer0.org1.example.com","peer1.org1.example.com"],
					"fcn": "move",
					"args": args
				}), function (data) {
					$table.find("p").text(data);
				}, function (data) {
					$table.find("p").text(data);
				});
			});

			$(".query-tx").click(function () {
				$table = $(this).parents("table");
			
				var txId = $table.find("p").text();
				$get("channels/mychannel/transactions/" + txId + "?peer=peer0.org1.example.com", function (data) {
					$table.find("p").text("交易信息：" + data);
				}, function (data) {
					$table.find("p").text("交易信息：" + data);
				});
			});
			
			$(".query-block").click(function () {
				$table = $(this).parents("table");
				
				$get("channels/mychannel/blocks/" + $table.find(".blockIndex").val() + "?peer=peer0.org1.example.com", function (data) {
					$table.find("p").text(data);
				}, function (data) {
					$table.find("p").text(data);
				});
			});
		});
	</script>
</head>

<body>
	<div style="margin: 50px auto 50px;" align="center">
		
		<table width="50%">
			<thead>
				<tr>
					<th colspan="4">登陆&注册 —— 认证</th>
				</tr>
			</thead>
			
			<tr align="center">
				<td width="20%">用户名:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="username" value="Jim"/>
				</td>
				<td width="20%">组织:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="orgName" value="Org1"/>
				</td>
			</tr>
			<tr align="center">
				<td align="center" style="padding-left: 2em;" colspan="4">
					<input type="reset" value="&nbsp;&nbsp;清 空&nbsp;&nbsp;"/>&nbsp;&nbsp;
					<input type="button" class="login" value="&nbsp;&nbsp;执 行&nbsp;&nbsp;"/>
				</td>
			</tr>
			
			<tr align="center">
				<td>token 信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<p class="token-data"></p>
				</td>
			</tr>
		</table>
		
		<hr/>
		<table width="50%">
			<thead>
				<tr>
					<th colspan="3" width="80%">数据列表</th>
					<th>自动查询 <input type="checkbox" checked="checked"/></th>
				</tr>
			</thead>
			
			<tr align="center">
				<td width="20%">通道列表:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="channels">
					
				</td>
			</tr>
			<tr align="center" style="display: none;">
				<td width="20%">当前通道:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="channel-info">
					
				</td>
			</tr>
			<tr align="center">
				<td width="20%">安装合约信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="install-cc">
					
				</td>
			</tr>
			<tr align="center">
				<td width="20%">初始化合约信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="instantiated-cc">
					
				</td>
			</tr>
			<tr align="center">
				<td width="20%">A账户资产信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="a-account">
					
				</td>
			</tr>
			<tr align="center">
				<td width="20%">B账户资产信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="b-account">
					
				</td>
			</tr>
		</table>
		
		<hr/>

		<table width="50%">
			<thead>
				<tr>
					<th colspan="4">创建账户</th>
				</tr>
			</thead>
			
			<tr align="center">
				<td width="20%">Token:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<input type="text" class="token" value="" style="width: 500px;"/>
				</td>
			</tr>
			<tr align="center">
				<td width="20%">通道名称:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="channelName" value="mychannel" readonly="readonly"/>
				</td>
				<td width="20%">选择合约类型:</td>
				<td align="left" style="padding-left: 2em;">
					<select>
						<option value="nodejs">NodeJS</option>
						<option value="go" selected="selected">GoLang</option>
					</select>
				</td>
			</tr>
			<tr align="center">
				<td width="20%">合约名称:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="chaincodeName" value="mycc" readonly="readonly"/>
				</td>
				<td width="20%">合约路径:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="chaincodePath" value="github.com/example_cc/go" readonly="readonly"/>
				</td>
			</tr>
			<tr align="center">
				<td width="20%">合约类型:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="chaincodeType" value="golang" readonly="readonly"/>
				</td>
				<td width="20%">合约版本:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="chaincodeVersion" value="v0" readonly="readonly"/>
				</td>
			</tr>
			<tr align="center">
				<td width="20%">A账户-初始金额:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="a" value="100"/>
				</td>
				<td width="20%">B账户-初始金额:</td>
				<td align="left" style="padding-left: 2em;">
					<input type="text" class="b" value="200"/>
				</td>
			</tr>
			<tr align="center">
				<td align="center" style="padding-left: 2em;" colspan="4">
					<input type="button" class="create-account" value="&nbsp;&nbsp;创建账户&nbsp;&nbsp;"/>
				</td>
			</tr>
			
			<tr align="center">
				<td>返回信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3" class="result">
				</td>
			</tr>
		</table>
		
		<hr/>

		<table width="50%">
			<thead>
				<tr>
					<th colspan="4">交易转账</th>
				</tr>
			</thead>
			
			<tr align="center">
				<td width="20%">Token:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<input type="text" class="token" value="" style="width: 500px;"/>
				</td>
			</tr>
			
			<tr align="center">
				<td width="20%">交易参数:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<select>
						<option value="1">A向B转账</option>
						<option value="2">B向A转账</option>
					</select>
					<input type="text" class="money" value='10' />
				</td>
			</tr>
			<tr align="center">
				<td align="center" style="padding-left: 2em;" colspan="4">
					<input type="reset" value="&nbsp;&nbsp;清 空&nbsp;&nbsp;"/>&nbsp;&nbsp;
					<input type="button" class="invoke" value="&nbsp;&nbsp;执 行&nbsp;&nbsp;"/>
					<input type="button" class="query-tx" value="&nbsp;&nbsp;查询交易&nbsp;&nbsp;"/>
				</td>
			</tr>
			
			<tr align="center">
				<td>返回信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<p></p>
				</td>
			</tr>
		</table>
		
		<hr/>
		<table width="50%">
			<thead>
				<tr>
					<th colspan="4">区块查询</th>
				</tr>
			</thead>
			
			<tr align="center">
				<td width="200">Token:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<input type="text" class="token" value="" style="width: 500px;"/>
				</td>
			</tr>
			
			<tr align="center">
				<td width="20%">区块索引:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<input type="text" class="blockIndex" value='1' style="width: 500px;"/>
				</td>
			</tr>
			<tr align="center">
				<td align="center" style="padding-left: 2em;" colspan="4">
					<input type="reset" value="&nbsp;&nbsp;清 空&nbsp;&nbsp;"/>&nbsp;&nbsp;
					<input type="button" class="query-block" value="&nbsp;&nbsp;执 行&nbsp;&nbsp;"/>
				</td>
			</tr>
			
			<tr align="center">
				<td>返回信息:</td>
				<td align="left" style="padding-left: 2em;" colspan="3">
					<p></p>
				</td>
			</tr>
		</table>
		
		
	</div>
	
</body>
</html>
