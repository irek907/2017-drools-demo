package com.myhexin.web;

import javax.servlet.http.HttpServletRequest;

import org.kie.api.KieBase;
import org.kie.api.KieServices;
import org.kie.api.builder.KieBuilder;
import org.kie.api.builder.KieFileSystem;
import org.kie.api.builder.Results;
import org.kie.api.event.rule.DebugAgendaEventListener;
import org.kie.api.event.rule.DebugRuleRuntimeEventListener;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.myhexin.entity.Book;
import com.myhexin.service.IBookService;



import java.io.UnsupportedEncodingException;  

import org.drools.KnowledgeBase;  
import org.drools.KnowledgeBaseFactory;  
import org.drools.builder.KnowledgeBuilder;  
import org.drools.builder.KnowledgeBuilderError;  
import org.drools.builder.KnowledgeBuilderErrors;  
import org.drools.builder.KnowledgeBuilderFactory;  
import org.drools.builder.ResourceType;  
import org.drools.io.ResourceFactory;  
import org.drools.runtime.StatefulKnowledgeSession; 

@Controller
@RequestMapping("/book")
public class BookController {

	@Autowired
	private IBookService iBookService;

	/**
	 * 购买一本书
	 * 
	 * @return
	 */
	@RequestMapping(value = "/order")
	@ResponseBody
	public Object orderOneBook(HttpServletRequest request) {
		Book b = new Book();
		b.setBasePrice(100);
		b.setClz("computer");
		b.setName("C plus programing");
		b.setSalesArea("China");
		b.setYears(2);

		double realPrice = iBookService.getBookSalePrice(b);
		request.setAttribute("book", b);
		System.out.println(b.getName() + ":" + realPrice);

		return b;
	}
	
	public static void main(String[] args) {
		new BookController().test2();
	}
	
	public void test2(){
		 //rule,rule2可以放在数据库中，有个唯一code和他们对于，代码要执行规则的时候，根据code从数据库获取出来就OK了，这样自己开发的规则管理系统那边对数据库里的规则进行维护就行了  
        String rule = "package com.fei.drools\r\n";  
        rule += "import com.myhexin.web.Message2;\r\n";  
        rule += "rule \"rule1\"\r\n";  
        rule += "\twhen\r\n";  
        rule += "Message2( status == 1, myMessage : msg )";  
        rule += "\tthen\r\n";  
        rule += "\t\tSystem.out.println( 1+\":\"+myMessage );\r\n";  
        rule += "end\r\n";  
        
        System.out.println(rule);
        
        System.out.println("---------------------");
          
          
        String rule2 = "package com.fei.drools\r\n";  
        rule2 += "import com.myhexin.web.Message3;\r\n";  
          
        rule2 += "rule \"rule2\"\r\n";  
        rule2 += "\twhen\r\n";  
        rule2 += "Message3( status == 2, myMessage : msg )";  
        rule2 += "\tthen\r\n";  
        rule2 += "\t\tSystem.out.println( 2+\":\"+myMessage );\r\n";  
        rule2 += "end\r\n";  
          
        System.out.println(rule2);
          
        StatefulKnowledgeSession kSession = null;  
        try {  
              
              
            KnowledgeBuilder kb = KnowledgeBuilderFactory.newKnowledgeBuilder();  
            //装入规则，可以装入多个  
            kb.add(ResourceFactory.newByteArrayResource(rule.getBytes("utf-8")), ResourceType.DRL);  
            kb.add(ResourceFactory.newByteArrayResource(rule2.getBytes("utf-8")), ResourceType.DRL);  
              
            KnowledgeBuilderErrors errors = kb.getErrors();  
            for (KnowledgeBuilderError error : errors) {  
                System.out.println(error);  
            }  
            KnowledgeBase kBase = KnowledgeBaseFactory.newKnowledgeBase();  
            kBase.addKnowledgePackages(kb.getKnowledgePackages());  
              
            kSession = kBase.newStatefulKnowledgeSession();  
  
              
            Message2 message1 = new Message2();  
            message1.setStatus(1);  
            message1.setMsg("hello world!");  
              
            Message3 message2 = new Message3();  
            message2.setStatus(2);  
            message2.setMsg("hi world!");  
              
            kSession.insert(message1);  
            kSession.insert(message2);  
            kSession.fireAllRules();  
  
        } catch (UnsupportedEncodingException e) {  
            e.printStackTrace();  
        } finally {  
            if (kSession != null)  
                kSession.dispose();  
        }  
	}
	
	public void test(){
		String rule = "package com.sy\r\n";
		rule += "import com.myhexin.web.Message;\r\n";
		rule += "rule \"Hello World\"\r\n";
		rule += "\twhen\r\n";
		rule += "m : Message( status == Message.HELLO, myMessage : message )";
		rule += "\tthen\r\n";
		rule += "\t\tSystem.out.println( myMessage );\r\n";
		rule += "\t\tm.setMessage(\"Goodbye cruel world\");\r\n";
		rule += "\t\tm.setStatus( Message.GOODBYE );;\r\n";
		rule += "\t\tupdate( m );;\r\n";
		rule += "end\r\n";
		
		rule += "rule \"GoodBye\"\r\n";
		rule += "\twhen\r\n";
		rule += "Message( status == Message.GOODBYE, myMessage : message )";
		rule += "\tthen\r\n";
		rule += "\t\tSystem.out.println( 2+\":\"+myMessage );\r\n";
		rule += "end\r\n";
		
		KieServices kieServices = KieServices.Factory.get();
	    KieFileSystem kfs = kieServices.newKieFileSystem();
	    kfs.write( "src/main/resources/rules/ruless.drl",rule.getBytes());
	    KieBuilder kieBuilder = kieServices.newKieBuilder( kfs ).buildAll();
	    Results results = kieBuilder.getResults();
	    if( results.hasMessages( org.kie.api.builder.Message.Level.ERROR ) ){
	        System.out.println("--:"+ results.getMessages() );
	        throw new IllegalStateException( "### errors ###" );
	    }
	    KieContainer kieContainer = kieServices.newKieContainer( kieServices.getRepository().getDefaultReleaseId() );
	    KieBase kieBase = kieContainer.getKieBase();
	    
	    
	    
	    KieSession ksession = kieBase.newKieSession();
	    
	    Message message = new Message();
        message.setMessage("Hello World");
        message.setStatus(Message.HELLO);
        
        Message message2 = new Message();
		message2.setStatus(Message.HELLO);
		message2.setMessage("hi world!");
        ksession.addEventListener( new DebugAgendaEventListener() );
        ksession.addEventListener( new DebugRuleRuntimeEventListener() );
        ksession.insert(message);
        ksession.insert(message2);
        ksession.fireAllRules();
	}
    
}
