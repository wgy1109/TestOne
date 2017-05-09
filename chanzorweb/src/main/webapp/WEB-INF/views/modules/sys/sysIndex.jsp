<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>${fns:getConfig('productName')}</title>
<meta name="decorator" content="blank" />
<c:set var="tabmode"
	value="${empty cookie.tabmode.value ? '1' : cookie.tabmode.value}" />
<c:if test="${tabmode eq '1'}">
	<link rel="Stylesheet"
		href="${ctxStatic}/jerichotab/css/jquery.jerichotab.css" />
	<script type="text/javascript"
		src="${ctxStatic}/jerichotab/js/jquery.jerichotab.js"></script>
</c:if>
<script src="${ctxStatic}/common/common.js" type="text/javascript"></script>
<style type="text/css">
#main {
	padding: 0;
	margin: 0;
}

#main .container-fluid {
	padding: 0 4px 0 6px;
}

#header {
	margin: 0 0 8px;
	position: static;
}

#header li {
	font-size: 16px;
	_font-size: 14px;
}

#footer {
	margin: 8px 0 0 0;
	padding: 3px 0 0 0;
	font-size: 11px;
	text-align: center;
	border-top: 2px solid #0663A2;
}

#footer, #footer a {
	color: #999;
}

#left {
	overflow-x: hidden;
	overflow-y: auto;
}

#left .collapse {
	position: static;
}

#userControl>li>a { 
	text-shadow: none;
}

#userControl>li>a:hover, #user #userControl>li.open>a {
	background: transparent;
}

.navbar-inner .brand {
	padding: 8px 5px 0 20px
}
</style>
<script type="text/javascript">
		$(document).ready(function() {
			$.fn.initJerichoTab({
                renderTo: '#right', uniqueId: 'jerichotab',
                contentCss: { 'height': $('#right').height() - tabTitleHeight },
                tabs: [], loadOnce: true, tabWidth: 110, titleHeight: tabTitleHeight
            });
			$("#menu a.menu").click(function(){
				// 一级菜单焦点
				$("#menu li.menu").removeClass("active");
				$(this).parent().addClass("active");
				// 左侧区域隐藏
				if ($(this).attr("target") == "mainFrame"){
					$("#left,#openClose").hide();
					wSizeWidth();
					$(".jericho_tab").hide();
					$("#mainFrame").show();
					return true;
				}
				// 左侧区域显示
				$("#left,#openClose").show();
				if(!$("#openClose").hasClass("close")){
					$("#openClose").click();
				}
				// 显示二级菜单
				var menuId = "#menu-" + $(this).attr("data-id");
				if ($(menuId).length > 0){
					$("#left .accordion").hide();
					$(menuId).show();
					// 初始化点击第一个二级菜单
					if (!$(menuId + " .accordion-body:first").hasClass('in')){
						$(menuId + " .accordion-heading:first a").click();
					}
					if (!$(menuId + " .accordion-body li:first ul:first").is(":visible")){
						$(menuId + " .accordion-body a:first i").click();
					}
					// 初始化点击第一个三级菜单
					$(menuId + " .accordion-body li:first li:first a:first i").click();
				}else{
					// 获取二级菜单数据
					$.get($(this).attr("data-href"), function(data){
						if (data.indexOf("id=\"loginForm\"") != -1){
							alert('未登录或登录超时。请重新登录，谢谢！');
							top.location = "${ctx}";
							return false;
						}
						$("#left .accordion").hide();
						$("#left").append(data);
						// 链接去掉虚框
						$(menuId + " a").bind("focus",function() {
							if(this.blur) {this.blur()};
						});
						// 二级标题
						$(menuId + " .accordion-heading a").click(function(){
							$(menuId + " .accordion-toggle i").removeClass('icon-chevron-down').addClass('icon-chevron-right');
							if(!$($(this).attr('data-href')).hasClass('in')){
								$(this).children("i").removeClass('icon-chevron-right').addClass('icon-chevron-down');
							}
						});
						// 二级内容
						$(menuId + " .accordion-body a").click(function(){
							$(menuId + " li").removeClass("active");
							$(menuId + " li i").removeClass("icon-white");
							$(this).parent().addClass("active");
							$(this).children("i").addClass("icon-white");
						});
						// 展现三级
						$(menuId + " .accordion-inner a").click(function(){
							var href = $(this).attr("data-href");
							if($(href).length > 0){
								$(href).toggle().parent().toggle();
								return false;
							}
							return addTab($(this)); 
						});
						// 默认选中第一个菜单
						$(menuId + " .accordion-body a:first i").click();
						$(menuId + " .accordion-body li:first li:first a:first i").click();
					});
				}
				// 大小宽度调整
				wSizeWidth();
				return false;
			});
			$("#smsAuditPrompt").click(function(){
					wSizeWidth();
					$("#mainFrame").show();
					return addTab($(this));
			});
			// 初始化点击第一个一级菜单
			$("#menu a.menu:first span").click();
			$("#userInfo .dropdown-menu a").mouseup(function(){
				return addTab($(this), true);
			});
			// 鼠标移动到边界自动弹出左侧菜单
			$("#openClose").mouseover(function(){
				if($(this).hasClass("open")){
					$(this).click();
				}
			});
			   
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
		function addTab($this, refresh){
			$(".jericho_tab").show();
			$("#mainFrame").hide();
			var thisTitle = $this.text();
			if(thisTitle.length <= 2){
				thisTitle = "短信审核";
			}
			$.fn.jerichoTab.addTab({
                tabFirer: $this,
                title: thisTitle,
                closeable: true,
                data: {
                    dataType: 'iframe',
                    dataLink: $this.attr('href')
                }
            }).loadData(refresh);
			return false;
		}
	
		function dealwithRightNow(){
			$("#myModalLabel_edit").show();
			$("#contactTypeDiv").show();
			$("#contactStatusDiv").show();
			$("#contactTimeDiv").show();
			$("#contactContent").attr("readonly",false);
			$("#contactResult").attr("readonly",false);
			$("#contactCommentDiv").show();
			$("#remindDelayDiv").hide();
			
			$("#closeRemindButton").hide();
			$("#closeButton").show();
			$("#dealwithButton").hide();
			$("#modifyButton").show();
		}
		
		function saveRemindContact(){
			
		}
		function findUrl(url){
	   if(url.indexOf("searchHistory")>0){
		    	      $.get("${ctx}/sys/user/findLoginUser",function(data){
		    	    	  $.ajax({
		    					async : false,
		    					url : data.info.historyLogUrl,
		    					type : 'post',
		    					data : data.info,
		    					dataType : 'JSONP',// here
		    					success : function(data) {
		    						if(data.reutrnCode=='success'){
			    						window.open(data.info.historyLogIndex);
		    						}else{
		    							layer.msg("当前用户没有权限访问历史数据");
		    						}
		    						
		    					}
		    				});
		    	      })
	          }
		}
	</script>
</head>
<body>
	<div id="main">
		<div id="header" class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="brand">
					<span id="productName"><img alt=""
						src="${ctxStatic}/images/mainpage1.png" /></span>
				</div>
				<ul id="userControl" class="nav pull-right">
					<%-- <li><a href="${ctx}/domesticSms/smsAudit/list"
						target="mainFrame" id="smsAuditPrompt"><p
								class="domesticSmsAudit float_left"></p>
							<p id="showSmsNum" class="float_left"></p></a></li> --%>
					<!-- <li><a href="http://c.chanzor.com" target="_blank"
						title="访问客户端主页"><i class="icon-home"></i></a></li> -->
					<%-- <li id="themeSwitch" class="dropdown"><a
						class="dropdown-toggle" data-toggle="dropdown" href="#"
						title="主题切换"><i class="icon-th-large"></i></a>
						<ul class="dropdown-menu">
							<c:forEach items="${fns:getDictList('theme')}" var="dict">
								<li><a href="#"
									onclick="location='${pageContext.request.contextPath}/theme/${dict.value}?url='+location.href">${dict.label}</a></li>
							</c:forEach>
							<li><a
								href="javascript:cookie('tabmode','${tabmode eq '1' ? '0' : '1'}');location=location.href">${tabmode eq '1' ? '关闭' : '开启'}页签模式</a></li>
						</ul> 
					</li> --%>
					<li id="userInfo" class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#" title="个人信息">您好,
							${fns:getUser().name}&nbsp;<span id="notifyNum"
							class="label label-info hide"></span>
					</a>
						<ul class="dropdown-menu">
							<li><a href="${ctx}/sys/user/info" target="mainFrame"><i
									class="icon-user"></i>&nbsp; 个人信息</a></li>
							<li><a href="${ctx}/sys/user/modifyPwd" target="mainFrame"><i
									class="icon-lock"></i>&nbsp; 修改密码</a></li>
							<%-- <li><a href="${ctx}/oa/oaNotify/self" target="mainFrame"><i
									class="icon-bell"></i>&nbsp; 我的通知 <span id="notifyNum2"
									class="label label-info hide"></span></a></li> --%>
						</ul></li>
					<li><a href="${ctx}/logout" title="退出登录">退出</a></li>
					<li>&nbsp;</li>
				</ul>
				<div class="nav-collapse">
					<ul id="menu" class="nav"
						style="*white-space: nowrap; float: none;">
						<c:set var="firstMenu" value="true" />
						<c:forEach items="${fns:getMenuList()}" var="menu"
							varStatus="idxStatus">
							<c:if test="${menu.parent.id eq '1'&&menu.isShow eq '1'}">
								<li
									class="menu ${not empty firstMenu && firstMenu ? ' active' : ''}">
									<c:if test="${empty menu.href}">
										<a class="menu" href="javascript:"
											data-href="${ctx}/sys/menu/tree?parentId=${menu.id}"
											data-id="${menu.id}"><span>${menu.name}</span></a>
									</c:if> <c:if test="${not empty menu.href}">
										<a class="button-menu" href="javascript:;"
											data-id="${menu.id}" onclick="findUrl('${menu.href}')"><span>${menu.name}</span></a>
									</c:if>
								</li>
								<c:if test="${firstMenu}">
									<c:set var="firstMenuId" value="${menu.id}" />
								</c:if>
								<c:set var="firstMenu" value="false" />
							</c:if>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
		<div class="container-fluid">
			<div id="content" class="row-fluid">
				<div id="left">
				</div>
				<div id="openClose" class="close">&nbsp;</div>
				<div id="right">
					<iframe id="mainFrame" name="mainFrame" src=""
						style="overflow: visible;" scrolling="yes" frameborder="no"
						width="100%" height="650"></iframe>
				</div>
			</div>
			<div id="footer" class="row-fluid">
				Copyright &copy; 2012-${fns:getConfig('copyrightYear')}
				${fns:getConfig('productName')} - Powered By <a
					href="http://www.chanzor.com" target="_blank">Chanzor team</a>
				${fns:getConfig('version')}
			</div>
		</div>
	</div>
	</div>
	<script type="text/javascript"> 
		var leftWidth = 160; // 左侧窗口大小
		var tabTitleHeight = 33; // 页签的高度
		var htmlObj = $("html"), mainObj = $("#main");
		var headerObj = $("#header"), footerObj = $("#footer");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var minHeight = 500, minWidth = 980;
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":strs[1] < minWidth ? "auto" : "hidden", "overflow-y":strs[0] < minHeight ? "auto" : "hidden"});
			mainObj.css("width",strs[1] < minWidth ? minWidth - 10 : "auto");
			frameObj.height((strs[0] < minHeight ? minHeight : strs[0]) - headerObj.height() - footerObj.height() - (strs[1] < minWidth ? 42 : 28));
			$("#openClose").height($("#openClose").height() - 5);
			$(".jericho_tab iframe").height($("#right").height() - tabTitleHeight); 
			wSizeWidth();
		}
		function wSizeWidth(){
			if (!$("#openClose").is(":hidden")){
				var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
				$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -5);
			}else{
				$("#right").width("100%");
			}
		}
		function openCloseClickCallBack(b){
			$.fn.jerichoTab.resize();
		} 
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
</body>
</html>