<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<meta HTTP-EQUIV="Expires" CONTENT="-1" />
<link rel="shortcut icon" href="images/favicon.png" />
<link rel="icon" href="images/favicon.png" />
<title>软件中心 - syncthing</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/disk_functions.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style type="text/css">
	.mask_bg{
		position:absolute;
		margin:auto;
		top:0;
		left:0;
		width:100%;
		height:100%;
		z-index:100;
		/*background-color: #FFF;*/
		background:url(images/popup_bg2.gif);
		background-repeat: repeat;
		filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
	 -moz-opacity: 0.6;
		display:none;
		/*visibility:hidden;*/
		overflow:hidden;
	}
	.mask_floder_bg{
		position:absolute;
		margin:auto;
		top:0;
		left:0;
		width:100%;
		height:100%;
		z-index:300;
		/*background-color: #FFF;*/
		background:url(images/popup_bg2.gif);
		background-repeat: repeat;
		filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
		-moz-opacity: 0.6;
		display:none;
		/*visibility:hidden;*/
		overflow:hidden;
	}
		.folderClicked{
		color:#569AC7;
		font-size:14px;
		cursor:text;
	}
	.lastfolderClicked{
		color:#FFFFFF;
		cursor:pointer;
	}
	.show-btn1, .show-btn2, .show-btn3, .show-btn4, .show-btn5, .show-btn6 {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 10px 3.75px;
		border-radius: 5px 5px 0px 0px;
		width:8.45601%;
		background: linear-gradient(to bottom, #919fa4  0%, #67767d 100%);
		background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
		border: 1px solid #91071f; /* W3C rogcss */
		background: none; /* W3C rogcss */
	}
	.active {
		background: #2f3a3e;
		background: linear-gradient(to bottom, #61b5de  0%, #279fd9 100%);
		background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
		border: 1px solid #91071f; /* W3C rogcss */
	}
	input[type=button]:focus {
		outline: none;
	}
	textarea{
		width:99%;
		font-family:'Lucida Console';
		font-size:12px;
		color:#FFFFFF;
		background:#475A5F;
		background:transparent; /* W3C rogcss */
		border:1px solid #91071f; /* W3C rogcss */
	}
	.popup_bar_bg_ks{
		position:fixed;	
		margin: auto;
		top: 0;
		left: 0;
		width:100%;
		height:100%;
		z-index:99;
		filter:alpha(opacity=90);
		background-repeat: repeat;
		visibility:hidden;
		overflow:hidden;
		background-color: #444F53;
		background:rgba(68, 79, 83, 0.9) none repeat scroll 0 0 !important;
		background: url(/images/New_ui/login_bg.png); /* W3C rogcss */
		background-position: 0 0; /* W3C rogcss */
		background-size: cover; /* W3C rogcss */
		opacity: .94; /* W3C rogcss */
	}
	#log_content3, #loading_block2, #log_content1 {
		line-height:1.5
	}
	em {
		color: #00ffe4;
		font-style: normal;
	}
</style>
<script>
	var db_syncthing = {}
	var FromObject = "0";
	var lastClickedObj = 0;
	var disk_flag = 0;
	window.onresize = cal_panel_block;
	function init() {
		show_menu(menu_hook);
		get_dbus_data();
	}
	function get_dbus_data() {
		$.ajax({
			type: "GET",
			url: "/dbconf?p=syncthing_",
			dataType: "script",
			async: false,
			success: function(data) {
				db_syncthing = db_syncthing_;
				E("syncthing_enable").checked = db_syncthing["syncthing_enable"] == "1";
				E("syncthing_wan_port").value = db_syncthing["syncthing_wan_port"] || "0";
				E("syncthing_port").value = db_syncthing["syncthing_port"] || "8384";
				E("syncthing_run_path").value = db_syncthing["syncthing_run_path"] || "~/.config/syncthing";
				get_run_status();
			}
		});
	}
	function save() {
		showLoading(3);
		refreshpage(3);
		if(E("syncthing_port").value == 80 || E("syncthing_port").value == 8443)
			E("syncthing_port").value = 8384;
		db_syncthing["syncthing_enable"] = E("syncthing_enable").checked ? '1' : '0';
		db_syncthing["syncthing_wan_port"] = E("syncthing_wan_port").value;
		db_syncthing["syncthing_port"] = E("syncthing_port").value;
		db_syncthing["syncthing_run_path"] = E("syncthing_run_path").value;
		db_syncthing["action_script"]="syncthing_config.sh";
		db_syncthing["action_mode"] = "restart";
		$.ajax({
			url: "/applydb.cgi?p=syncthing",
			cache: false,
			type: "POST",
			dataType: "text",
			data: $.param(db_syncthing)
		});
	}
	function get_layer_items(path){
		if(path == "0"){
			get_layer_items_l(path)
			return;
		}
		db_syncthing["action_script"]="syncthing_disk.sh";
		db_syncthing["action_mode"] = path;
		$.ajax({
			url: "/applydb.cgi?p=syncthing",
			cache: false,
			async:false,
			type: "POST",
			dataType: "text",
			data: $.param(db_syncthing)
		});
		setTimeout(
			function(){
				$.ajax({
				type: "POST",
				cache:false,
				url: "/logreaddb.cgi?script=syncthing_disk.sh&p=syncthing_disk.log&q=123",
				dataType: "script",
				success: function(){
					console.log(treeitems)
					get_tree_items(treeitems);
				},
				error: function(e){
					console.log(e);
				}
			});
		}, 1000);
	}

	function menu_hook(title, tab) {
		tabtitle[tabtitle.length -1] = new Array("", "软件中心", "离线安装", "syncthing");
		tablink[tablink.length -1] = new Array("", "Main_Soft_center.asp", "Main_Soft_setting.asp", "Module_syncthing.asp");
	}
	function get_run_status(){

		$.ajax({
			type: "POST",
			cache:false,
			url: "/logreaddb.cgi?p=syncthing_status.log&script=syncthing_status.sh",
			//data: JSON.stringify(postData),
			dataType: "html",
			success: function(response){
				//console.log(response)
				E("status").innerHTML = response;
				setTimeout("get_run_status();", 10000);
			},
			error: function(){
				setTimeout("get_run_status();", 5000);
			}
		});
	}
	function open_syncthing(){
		window.open("http://"+window.location.hostname+":"+E("syncthing_port").value);
	}
	function get_disk_tree() {
		if (disk_flag == 1) {
			alert('没有找到USB设备！');
			return false;
		}
		cal_panel_block();
		$("#folderTree_panel").fadeIn(300);
		get_layer_items("0");
	}
	function cal_panel_block() {
		var blockmarginLeft;
		if (window.innerWidth)
			winWidth = window.innerWidth;
		else if ((document.body) && (document.body.clientWidth))
			winWidth = document.body.clientWidth;
		if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
			winWidth = document.documentElement.clientWidth;
		}
		if (winWidth > 1050) {
			winPadding = (winWidth - 1050) / 2;
			winWidth = 1105;
			blockmarginLeft = (winWidth * 0.25) + winPadding;
		} else if (winWidth<= 1050) {
			blockmarginLeft = (winWidth) * 0.25 + document.body.scrollLeft;
		}
		E("folderTree_panel").style.marginLeft = blockmarginLeft + "px";
	}
	function get_layer_items_l(layer_order) {
		$.ajax({
			url: '/gettree.asp?layer_order=' + layer_order,
			dataType: 'script',
			error: function(xhr) {;
			},
			success: function() {
				get_tree_items(treeitems);
			}
		});
	}
	function get_tree_items(treeitems) {
		document.aidiskForm.test_flag.value = 0;
		this.isLoading = 1;
		var array_temp = new Array();
		var array_temp_split = new Array();
		for (var j = 0; j < treeitems.length; j++) { // To hide folder 'Download2'
			array_temp_split[j] = treeitems[j].split("#");
			if (array_temp_split[j][0].match(/^asusware$/)) {
				continue;
			}
			array_temp.push(treeitems[j]);
		}
		this.Items = array_temp;
		if (this.Items && this.Items.length >= 0) {
			BuildTree();
		}
	}
	function BuildTree() {
		var ItemText, ItemSub, ItemIcon;
		var vertline, isSubTree;
		var layer;
		var short_ItemText = "";
		var shown_ItemText = "";
		var ItemBarCode = "";
		var TempObject = "";
		for (var i = 0; i < this.Items.length; ++i) {
			this.Items[i] = this.Items[i].split("#");
			var Item_size = 0;
			Item_size = this.Items[i].length;
			if (Item_size > 3) {
				var temp_array = new Array(3);
				temp_array[2] = this.Items[i][Item_size - 1];
				temp_array[1] = this.Items[i][Item_size - 2];
				temp_array[0] = "";
				for (var j = 0; j < Item_size - 2; ++j) {
					if (j != 0)
						temp_array[0] += "#";
					temp_array[0] += this.Items[i][j];
				}
				this.Items[i] = temp_array;
			}
			ItemText = (this.Items[i][0]).replace(/^[\s]+/gi, "").replace(/[\s]+$/gi, "");
			ItemBarCode = this.FromObject + "_" + (this.Items[i][1]).replace(/^[\s]+/gi, "").replace(/[\s]+$/gi, "");
			ItemSub = parseInt((this.Items[i][2]).replace(/^[\s]+/gi, "").replace(/[\s]+$/gi, ""));
			layer = get_layer(ItemBarCode.substring(1));
			if (layer == 3) {
				if (ItemText.length > 21)
					short_ItemText = ItemText.substring(0, 30) + "...";
				else
					short_ItemText = ItemText;
			} else
				short_ItemText = ItemText;
			shown_ItemText = showhtmlspace(short_ItemText);
			if (layer == 1)
				ItemIcon = 'disk';
			else if (layer == 2)
				ItemIcon = 'part';
			else
				ItemIcon = 'folders';
			SubClick = ' onclick="GetFolderItem(this, ';
			if (ItemSub<= 0) {
				SubClick += '0);"';
				isSubTree = 'n';
			} else {
				SubClick += '1);"';
				isSubTree = 's';
			}
			if (i == this.Items.length - 1) {
				vertline = '';
				isSubTree += '1';
			} else {
				vertline = ' background="/images/Tree/vert_line.gif"';
				isSubTree += '1';
			}
			if (layer == 2 && isSubTree == 'n1') { // Uee to rebuild folder tree if disk without folder, Jieming add at 2012/08/29
				document.aidiskForm.test_flag.value = 1;
			}
			TempObject += '<table class="tree_table" id="bug_test">';
			TempObject += '<tr>';
			// the line in the front.
			TempObject += '<td class="vert_line">';
			TempObject += '<img id="a' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' class="FdRead" src="/images/Tree/vert_line_' + isSubTree + '0.gif">';
			TempObject += '</td>';

			if( layer == 1 ){
				/*a: connect_line b: harddisc+name c:harddisc d:name e: next layer forder*/
				TempObject += '<td>';
				TempObject += '<table><tr><td>';
				TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
				TempObject += '</td><td>';
				TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>';
				TempObject += '</td></tr></table>';
				TempObject += '</td>';
				TempObject += '</tr>';
				TempObject += '<tr><td></td>';
				TempObject += '<td><div id="e' + ItemBarCode + '" ></div></td>';
			} else if (layer == 2){
				TempObject += '<td>';
				TempObject += '<table class="tree_table">';
				TempObject += '<tr>';
				TempObject += '<td class="vert_line">';
				TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
				TempObject += '</td>';
				TempObject += '<td class="FdText">';
				TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>';
				TempObject += '</td>';
				TempObject += '<td></td>';
				TempObject += '</tr>';
				TempObject += '</table>';
				TempObject += '</td>';
				TempObject += '</tr>';
				TempObject += '<tr><td></td>';
				TempObject += '<td colspan=2><div id="e' + ItemBarCode + '" ></div></td>';
			}else{
				/*a: connect_line b: harddisc+name c:harddisc d:name e: next layer forder*/
				/*
				TempObject += '<td>';
				TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
				TempObject += '</td>';
				TempObject += '<td>';
				TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>\n';
				TempObject += '</td>';*/

				TempObject += '<td>';
				TempObject += '<table class="tree_table">';
				TempObject += '<tr>';
				TempObject += '<td class="vert_line">';
				TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
				TempObject += '</td>';
				TempObject += '<td class="FdText">';
				TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>';
				TempObject += '</td>';
				TempObject += '<td></td>';
				TempObject += '</tr>';
				TempObject += '</table>';
				TempObject += '</td>';
				TempObject += '</tr>';
				TempObject += '<tr><td></td>';
				TempObject += '<td colspan=2><div id="e' + ItemBarCode + '" ></div></td>';
			}



			TempObject += '</tr>';
		}
		TempObject += '</table>';
		E("e" + this.FromObject).innerHTML = TempObject;
	}
	function get_layer(barcode) {
		var tmp, layer;
		layer = 0;
		while (barcode.indexOf('_') != -1) {
			barcode = barcode.substring(barcode.indexOf('_'), barcode.length);
			++layer;
			barcode = barcode.substring(1);
		}
		return layer;
	}
	function build_array(obj, layer) {
		var path_temp = "/mnt";
		var layer2_path = "";
		var layer3_path = "";
		if (obj.id.length > 6) {
			var back_id = obj.id
			if (layer >= 3) {
				layer3_path = "/" + obj.title;
				while (layer3_path.indexOf("&nbsp;") != -1)
					layer3_path = layer3_path.replace("&nbsp;", " ");
					do {
						var back_id = back_id.substring(0, back_id.length - 2);
						layer2_path = "/" + E(back_id).innerHTML+layer2_path;
						while (layer2_path.indexOf("&nbsp;") != -1)
							layer2_path = layer2_path.replace("&nbsp;", " ");
					} while (back_id.length > 6);
			}
		}
		if (obj.id.length > 4 && obj.id.length<= 6) {
			if (layer == 2) {
				layer2_path = "/" + obj.title;
				while (layer2_path.indexOf("&nbsp;") != -1)
					layer2_path = layer2_path.replace("&nbsp;", " ");
			}
		}
		path_temp = path_temp + layer2_path + layer3_path;
		return path_temp;
	}
	function GetFolderItem(selectedObj, haveSubTree) {
		var barcode, layer = 0;
		showClickedObj(selectedObj);
		barcode = selectedObj.id.substring(1);
		layer = get_layer(barcode);
		if (layer == 0)
			alert("Machine: Wrong");
		else if (layer == 1) {
			// chose Disk
			setSelectedDiskOrder(selectedObj.id);
			path_directory = build_array(selectedObj, layer);
			E('createFolderBtn').className = "createFolderBtn";
			E('deleteFolderBtn').className = "deleteFolderBtn";
			E('modifyFolderBtn').className = "modifyFolderBtn";
			E('createFolderBtn').onclick = function() {};
			E('deleteFolderBtn').onclick = function() {};
			E('modifyFolderBtn').onclick = function() {};
		} else if (layer == 2) {
			// chose Partition
			setSelectedPoolOrder(selectedObj.id);
			path_directory = build_array(selectedObj, layer);
			E('createFolderBtn').className = "createFolderBtn_add";
			E('deleteFolderBtn').className = "deleteFolderBtn";
			E('modifyFolderBtn').className = "modifyFolderBtn";
			E('createFolderBtn').onclick = function() {
				popupWindow('OverlayMask', '/aidisk/popCreateFolder.asp');
			};
			E('deleteFolderBtn').onclick = function() {};
			E('modifyFolderBtn').onclick = function() {};
			document.aidiskForm.layer_order.disabled = "disabled";
			document.aidiskForm.layer_order.value = barcode;
		} else {
			// chose Shared-Folder
			setSelectedFolderOrder(selectedObj.id);
			path_directory = build_array(selectedObj, layer);
			E('createFolderBtn').className = "createFolderBtn";
			E('deleteFolderBtn').className = "deleteFolderBtn_add";
			E('modifyFolderBtn').className = "modifyFolderBtn_add";
			E('createFolderBtn').onclick = function() {};
			E('deleteFolderBtn').onclick = function() {
				popupWindow('OverlayMask', '/aidisk/popDeleteFolder.asp');
			};
			E('modifyFolderBtn').onclick = function() {
				popupWindow('OverlayMask', '/aidisk/popModifyFolder.asp');
			};
			document.aidiskForm.layer_order.disabled = "disabled";
			document.aidiskForm.layer_order.value = barcode;
		}
		if (haveSubTree)
			GetTree(barcode, 1);
	}
	function showClickedObj(clickedObj) {
		if (this.lastClickedObj != 0)
			this.lastClickedObj.className = "lastfolderClicked"; //this className set in AiDisk_style.css
		clickedObj.className = "folderClicked";
		this.lastClickedObj = clickedObj;
	}
	function GetTree(layer_order, v) {
		if (layer_order == "0") {
			this.FromObject = layer_order;
			E('d' + layer_order).innerHTML = '<span class="FdWait">. . . . . . . . . .</span>';
			setTimeout('get_layer_items("' + layer_order + '", "gettree")', 1);
			return;
		}
		if (E('a' + layer_order).className == "FdRead") {
			E('a' + layer_order).className = "FdOpen";
			E('a' + layer_order).src = "/images/Tree/vert_line_s" + v + "1.gif";
			this.FromObject = layer_order;
			E('e' + layer_order).innerHTML = '<img src="/images/Tree/folder_wait.gif">';
			setTimeout('get_layer_items("' + layer_order + '", "gettree")', 1);
		} else if (E('a' + layer_order).className == "FdOpen") {
			E('a' + layer_order).className = "FdClose";
			E('a' + layer_order).src = "/images/Tree/vert_line_s" + v + "0.gif";
			E('e' + layer_order).style.position = "absolute";
			E('e' + layer_order).style.visibility = "hidden";
		} else if (E('a' + layer_order).className == "FdClose") {
			E('a' + layer_order).className = "FdOpen";
			E('a' + layer_order).src = "/images/Tree/vert_line_s" + v + "1.gif";
			E('e' + layer_order).style.position = "";
			E('e' + layer_order).style.visibility = "";
		} else
			alert("Error when show the folder-tree!");
	}
	function cancel_folderTree() {
		this.FromObject = "0";
		$("#folderTree_panel").fadeOut(300);
	}
	function confirm_folderTree() {
		E('syncthing_run_path').value = path_directory;
		this.FromObject = "0";
		$("#folderTree_panel").fadeOut(300);
	}
	function cal_panel_block() {
		var blockmarginLeft;
		if (window.innerWidth)
			winWidth = window.innerWidth;
		else if ((document.body) && (document.body.clientWidth))
			winWidth = document.body.clientWidth;
		if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
			winWidth = document.documentElement.clientWidth;
		}
		if (winWidth > 1050) {
			winPadding = (winWidth - 1050) / 2;
			winWidth = 1105;
			blockmarginLeft = (winWidth * 0.25) + winPadding;
		} else if (winWidth<= 1050) {
			blockmarginLeft = (winWidth) * 0.25 + document.body.scrollLeft;
		}
		E("folderTree_panel").style.marginLeft = blockmarginLeft + "px";
	}
	function check_dir_path() {
		var dir_array = E('syncthing_run_path').value.split("/");
		if (dir_array[dir_array.length - 1].length > 21)
			E('syncthing_run_path').value = "/" + dir_array[1] + "/" + dir_array[2] + "/" + dir_array[dir_array.length - 1].substring(0, 18) + "...";
	}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<!-- floder tree-->
	<div id="DM_mask" class="mask_bg"></div>
	<div id="folderTree_panel" class="panel_folder">
		<table>
			<tr>
				<td>
					<div class="machineName" style="width:200px;font-family:Microsoft JhengHei;font-size:12pt;font-weight:bolder; margin-top:15px;margin-left:30px;">选择配置存储路径</div>
				</td>
				<td>
					<div style="width:240px;margin-top:17px;margin-left:125px;">
						<table>
							<tr>
								<td>
									<div id="createFolderBtn" class="createFolderBtn" title="<#AddFolderTitle#>"></div>
								</td>
								<td>
									<div id="deleteFolderBtn" class="deleteFolderBtn" title="<#DelFolderTitle#>"></div>
								</td>
								<td>
									<div id="modifyFolderBtn" class="modifyFolderBtn" title="<#ModFolderTitle#>"></div>
								</td>
							<tr>
						</table>
					</div>
				</td>
				</tr>
		</table>
		<div id="e0" class="folder_tree"></div>
		<div style="background-image:url(images/Tree/bg_02.png);background-repeat:no-repeat;height:90px;">
			<input class="button_gen" type="button" style="margin-left:27%;margin-top:18px;" onclick="cancel_folderTree();" value="取消">
			<input class="button_gen" type="button" onclick="confirm_folderTree();" value="确认">
		</div>
	</div>
	<div id="DM_mask_floder" class="mask_floder_bg"></div>
	<!-- floder tree-->
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

	<form method="post" name="serverForm" action="/start_apply.htm" target="hidden_frame">
		<input type="hidden" name="action_mode" value="apply">
		<input type="hidden" name="action_script" value="restart_nasapps">
		<input type="hidden" name="action_wait" value="5">
		<input type="hidden" name="current_page" value="Module_aria2.asp">
		<input type="hidden" name="flag" value="">
		<input type="hidden" name="nfsd_" value="<% nvram_get(" nfsd_ "); %>">
	</form>
	<form method="post" name="aidiskForm" action="" target="hidden_frame">
		<input type="hidden" name="motion" id="motion" value="">
		<input type="hidden" name="layer_order" id="layer_order" value="">
		<input type="hidden" name="test_flag" value="" disabled="disabled">
		<input type="hidden" name="protocol" id="protocol" value="">
	</form>

		<input type="hidden" name="current_page" value="Module_syncthing.asp" />
		<input type="hidden" name="next_page" value="Module_syncthing.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
		<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>"/>
		<table class="content" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="17">&nbsp;</td>
				<td valign="top" width="202">
					<div id="mainMenu"></div>
					<div id="subMenu"></div>
				</td>
				<td valign="top">
					<div id="tabMenu" class="submenuBlock"></div>
					<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td align="left" valign="top">
								<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
									<tr>
										<td bgcolor="#4D595D" colspan="3" valign="top">
											<div>&nbsp;</div>
											<div style="float:left;" class="formfonttitle">数据同步工具 - syncthing</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="formfontdesc" id="cmdDesc">Syncthing用于同步数据，原生支持NAT穿透，通过映射Announce端口可以直接链接提高效率。</div>
											<div class="formfontdesc" id="cmdDesc">WebGUI 端口可以在本页面直接更改，重启Syncthing后生效</div>
											<div class="formfontdesc" id="cmdDesc">如需更改Announce端口，需要到WebGUI的“设置-高级-选项”中配置，重启Syncthing后生效</div>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="syncthing_table">
												<thead>
													<tr>
														<td colspan="2">syncthing 选项</td>
													</tr>
												</thead>
												<tr>
													<th>开启 syncthing</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="syncthing_enable">
																<input id="syncthing_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>

												<tr>
													<td style="width:25%;">
														<label>配置保存目录</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="syncthing_run_path" value="downloads" maxlength="50" size="40" ondblClick="get_disk_tree();" id="syncthing_run_path">
														<small></br>手动输入或者<i>双击输入框选择路径</i>，如果没有定义，将使用第一个USB设备的根目录.</small>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="35%">WebGUI 端口</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<input id="syncthing_port" name="syncthing_port" class="input_32_table" value="">
														</div>
													</td>
												</tr>
												<tr id="wan_port_tr">
													<th width="35%">外网开关</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<select id="syncthing_wan_port" name="syncthing_wan_port" style="width:164px;margin:0px 0px 0px 2px;" class="input_option">
																<option value="0">关闭</option>
																<option value="1">开启</option>
															</select>
														</div>
													</td>
												</tr>
											</table>
																					<!--beginning of syncthing install table-->
											<div id="syncthing_install_table" style="margin:10px 0px 0px 0px;">
												<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">Syncthing相关信息</td>
														</tr>
													</thead>
													<tr id="syncthing_status">
														<th style="width:25%;">运行状态</th>
														<td><span id="status">获取中...</span>
														</td>
													</tr>

													<tr id="syncthing_tr">
														<th style="width:25%;">Syncthing控制台</th>
														<td>
															<div style="padding-top:5px;">
																<span><input class="button_gen" style="width:auto" id="cmdBtn" onclick="open_syncthing();" type="button" value="WebGUI"/></span>
															</div>
														</td>
													</tr>
												</table>
											</div>
											<div class="apply_gen">
												<span><input class="button_gen" id="cmdBtn" onclick="save();" type="button" value="提交"/></span>
											</div> 

											<div id="NoteBox">
													<h2>使用说明：</h2>
													<h3>首次安装控制台没有账号密码，为了您的安全请手动设置</h3>
													<h3>同步目录最好在U盘内(/mnt/file/)创建文件夹 比如 /mnt/file/syncthing/dir1</h3>
													<h3>配置目录默认为(~/.config/syncthing),由于Syncthin的数据库会越来越大，首次运行建议一定把配置目录设置为硬盘内比如(/mnt/xxx/SyncConfig)</h3>
													<h3>无必要不要打开外网访问</h3>
													<h2>作者@沐心 QQ:285169134 Email:h@ph233.cn</h2>
													<h2>申明：本工具由Git开源项目封装 <a href="https://github.com/syncthing/syncthing" target="_blank">点我跳转</a></h2>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="10" align="center" valign="top"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
	<div id="footer"></div>
</body>
</html>

