<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
	
	<%
	
	String path = request.getContextPath();
	String myrule = 
	
	(String)request.getSession().getAttribute("myrule");
	//System.out.println(myrule);
	
	%>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <script type="text/javascript" charset="utf-8" src="jsp/utf8-jsp/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="jsp/utf8-jsp/ueditor.all.min.js"> </script>
        <script type="text/javascript" charset="utf-8" src="jsp/jquery-1.8.1.js"> </script>
    <!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
    <!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
    <script type="text/javascript" charset="utf-8" src="jsp/utf8-jsp/lang/zh-cn/zh-cn.js"></script>

    <style type="text/css">
        div{
            width:100%;
        }
    </style>
</head>
<body onload="">
<h2>Drools 规则动态更新到数据库</h2>
<div style="text-align:center!important">
 <script id="editor" type="text/plain" style="width:600px;height:400px;"></script>
 
 <div id="btns">
    <div>
        规则名称:<input id="r_name" value="my_rule" readonly="readonly"/>
        <button onclick="getPlainTxt()">更新规则到据库</button>
        <button onclick="testRule()">测试规则</button>
        
         <button onclick="setContent()">获取规则</button>
        

    </div>
   

</div>
<div>
  
</div>
</div>
 <script type="text/javascript">

    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
    var ue = UE.getEditor('editor');
    
  
    
   


    function isFocus(e){
        alert(UE.getEditor('editor').isFocus());
        UE.dom.domUtils.preventDefault(e)
    }
    function setblur(e){
        UE.getEditor('editor').blur();
        UE.dom.domUtils.preventDefault(e)
    }
    function insertHtml() {
        var value = prompt('插入html代码', '');
        UE.getEditor('editor').execCommand('insertHtml', value)
    }
    function createEditor() {
        enableBtn();
        UE.getEditor('editor');
    }
    function getAllHtml() {
        alert(UE.getEditor('editor').getAllHtml())
    }
    function getContent() {
        var arr = [];
        arr.push("使用editor.getContent()方法可以获得编辑器的内容");
        arr.push("内容为：");
        arr.push(UE.getEditor('editor').getContent());
        alert(arr.join("\n"));
    }
    function getPlainTxt() {
        var arr = [];
      //  arr.push("使用editor.getPlainTxt()方法可以获得编辑器的带格式的纯文本内容");
       // arr.push("内容为：");
        arr.push(UE.getEditor('editor').getPlainTxt());
        
        
        var content  =arr.join('\n') ;
        
        updatedb(UE.getEditor('editor').getPlainTxt());
        
        //alert(arr.join('\n'))
    }
    function setContent(isAppendTo) {
        var arr = [];
       // console.info(isAppendTo);
       // arr.push("使用editor.setContent('欢迎使用ueditor')方法可以设置编辑器的内容");
      
     
      //  UE.getEditor('editor').setContent(t, isAppendTo);
       // alert(arr.join("\n"));
       
        jQuery.ajax( {
    		url :  "<%=path%>/book/getrule.do",
    		type : "POST",
    		cache : false,
    		async : false,
    		dataType : "json",
    		data : {
    			"r_content" : "",
    			"r_name":""
    		},
    		success : function(json, textStatus) {
    			console.info(json);
    			//alert(json);
    			 UE.getEditor('editor').setContent(json, false);
    			 //console.info(json);
    		},
    		error : function(XMLHttpRequest, textStatus, errorThrown) {
    			setMessage("服务端异常！", "error");
    		}
    	});
    }
    function setDisabled() {
        UE.getEditor('editor').setDisabled('fullscreen');
        disableBtn("enable");
    }

    function setEnabled() {
        UE.getEditor('editor').setEnabled();
        enableBtn();
    }

    function getText() {
        //当你点击按钮时编辑区域已经失去了焦点，如果直接用getText将不会得到内容，所以要在选回来，然后取得内容
        var range = UE.getEditor('editor').selection.getRange();
        range.select();
        var txt = UE.getEditor('editor').selection.getText();
        alert(txt)
    }

    function getContentTxt() {
        var arr = [];
        arr.push("使用editor.getContentTxt()方法可以获得编辑器的纯文本内容");
        arr.push("编辑器的纯文本内容为：");
        arr.push(UE.getEditor('editor').getContentTxt());
        alert(arr.join("\n"));
    }
    function hasContent() {
        var arr = [];
        arr.push("使用editor.hasContents()方法判断编辑器里是否有内容");
        arr.push("判断结果为：");
        arr.push(UE.getEditor('editor').hasContents());
        alert(arr.join("\n"));
    }
    function setFocus() {
        UE.getEditor('editor').focus();
    }
    function deleteEditor() {
        disableBtn();
        UE.getEditor('editor').destroy();
    }
    function disableBtn(str) {
        var div = document.getElementById('btns');
        var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
        for (var i = 0, btn; btn = btns[i++];) {
            if (btn.id == str) {
                UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
            } else {
                btn.setAttribute("disabled", "true");
            }
        }
    }
    function enableBtn() {
        var div = document.getElementById('btns');
        var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
        for (var i = 0, btn; btn = btns[i++];) {
            UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
        }
    }

    function getLocalData () {
        alert(UE.getEditor('editor').execCommand( "getlocaldata" ));
    }

    function clearLocalData () {
        UE.getEditor('editor').execCommand( "clearlocaldata" );
        alert("已清空草稿箱")
    }
    
    function updatedb(data){
    	jQuery.ajax( {
    		url :  "<%=path%>/book/updatedata.do",
    		type : "POST",
    		cache : false,
    		async : false,
    		dataType : "json",
    		data : {
    			"r_content" : data,
    			"r_name":$("#r_name").val()
    		},
    		success : function(json, textStatus) {
    			if(json==1){
    				alert("成功！");
    			}
    			else
    				alert("失败！");
    			
    		},
    		error : function(XMLHttpRequest, textStatus, errorThrown) {
    			setMessage("服务端异常！", "error");
    		}
    	});
    	
    	
    }
    
    function testRule(){
    	jQuery.ajax( {
    		url :  "<%=path%>/book/testrule.do",
    		type : "POST",
    		cache : false,
    		async : false,
    		dataType : "json",
    		data : {
    			"r_content" : "",
    			"r_name":""
    		},
    		success : function(json, textStatus) {
    			if(json==1){
    				alert("成功！");
    			}
    			else
    				alert("失败！");
    			
    		},
    		error : function(XMLHttpRequest, textStatus, errorThrown) {
    			setMessage("服务端异常！", "error");
    		}
    	});
    }
    
    function getRule(){
    	jQuery.ajax( {
    		url :  "<%=path%>/book/getrule.do",
    		type : "POST",
    		cache : false,
    		async : false,
    		dataType : "json",
    		data : {
    			"r_content" : "",
    			"r_name":""
    		},
    		success : function(json, textStatus) {
    			
    			//alert(json);
    			// UE.getEditor('editor').setContent(json, false);
    			 //console.info(json);
    		},
    		error : function(XMLHttpRequest, textStatus, errorThrown) {
    			setMessage("服务端异常！", "error");
    		}
    	});
    }
</script>
</body>
</html>
