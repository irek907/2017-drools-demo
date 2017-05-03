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
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

<script type="text/javascript" charset="utf-8" src="jsp/jquery-1.8.1.js"> </script>


<style type="text/css">
div {
	width: 100%;
}
</style>
</head>
<body onload="javascript:setContent();">

	<div style="text-align: center !important">
		<h2>Drools 规则动态更新到数据库</h2>
		<textarea id="editor" rows="30" cols="100"></textarea>
		<div id="btns">
			<div>
				规则名称:<input id="r_name" value="my_rule" readonly="readonly" />
				value:<input id="r_type" value="1" />
				<button onclick="getPlainTxt()">更新规则到据库</button>
				<button onclick="testRule()">测试规则</button>

				<button onclick="setContent()">获取规则</button>


			</div>


		</div>
		<div></div>
	</div>
	<script type="text/javascript">

    //实例化编辑器
  
    ///
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
    			 //UE.getEditor('editor').setContent(json, false);
    			 
    			 $("#editor").val(json);
    			 //console.info(json);
    		},
    		error : function(XMLHttpRequest, textStatus, errorThrown) {
    			setMessage("服务端异常！", "error");
    		}
    	});
    }
    
    function getPlainTxt() {
       
        updatedb($("#editor").val());
       
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
    				alert("失败！"+json);
    			
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
    			"r_name":$("#r_type").val()
    		},
    		success : function(json, textStatus) {
    			console.info(json);
    			alert(JSON.stringify(json));
    		},
    		error : function(XMLHttpRequest, textStatus, errorThrown) {
    			alert("服务端异常！", "error");
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
