package com.myhexin.web;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.rowset.serial.SerialBlob;

import com.myhexin.entity.Rule;

public class DBTools {

	public static void main(String[] args){
		List<Rule> rList = queryList();
		System.out.println(rList);
		//update("test","xxxx11");
	}

	public static List<Rule>  queryList(){
		List<Rule> rList = new ArrayList<Rule>();
		try{
			//调用Class.forName()方法加载驱动程序
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("成功加载MySQL驱动！");
		}catch(ClassNotFoundException e1){
			System.out.println("找不到MySQL驱动!");
			e1.printStackTrace();
		}

		String url="jdbc:mysql://localhost:3306/drools";
		Connection conn = null;
		InputStream is = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			conn = DriverManager.getConnection(url,    "root","123456");
			//创建一个Statement对象
			stmt	 = conn.createStatement(); 
			String sql = "select r_name,r_content from tb_rule ";
			rs = stmt.executeQuery(sql);
			while (rs.next()){

				Rule r = new Rule();
				//System.out.print(rs.getString(1) + "\t");
				//System.out.print(rs.getBlob(2) + "\t");
				r.setR_name(rs.getString(1));
				is = rs.getBinaryStream("r_content");


				String result = "";

				if(is!=null){
					ByteArrayInputStream msgContent =(ByteArrayInputStream) is;
					byte[] byte_data = new byte[msgContent.available()];
					msgContent.read(byte_data, 0,byte_data.length);
					result = new String(byte_data);
					r.setR_content(result);
					//System.out.println(result);
				}

				rList.add(r);


			}

		} catch (SQLException e){
			e.printStackTrace();
		}finally{
			try{
				if(rs!=null)
					rs.close();
				if(stmt!=null)
					stmt.close();
				if(conn!=null)
					conn.close();
				if(is!=null)
					is.close();
			}catch(Exception e){
				e.printStackTrace();
			}

		}

		return rList;

	}
	public static boolean queryOne(String r_name){
		boolean f = false;
		try{
			//调用Class.forName()方法加载驱动程序
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("成功加载MySQL驱动！");
		}catch(ClassNotFoundException e1){
			System.out.println("找不到MySQL驱动!");
			e1.printStackTrace();
		}

		String url="jdbc:mysql://localhost:3306/drools";
		Connection conn;
		try {
			conn = DriverManager.getConnection(url,    "root","123456");
			//创建一个Statement对象
			Statement stmt = conn.createStatement(); 
			String sql = "select r_name,r_content from tb_rule where r_name = '"+r_name+"'";
			ResultSet rs = stmt.executeQuery(sql);

			while (rs.next()){
				f = true;
				break;
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e){
			e.printStackTrace();
		}
		return f;
	}
	public static String queryOne2(String r_name){
		try{
			//调用Class.forName()方法加载驱动程序
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("成功加载MySQL驱动！");
		}catch(ClassNotFoundException e1){
			System.out.println("找不到MySQL驱动!");
			e1.printStackTrace();
		}

		String url="jdbc:mysql://localhost:3306/drools";
		Connection conn = null;
		InputStream is = null;
		String result = "";
		Statement stmt = null;
		ResultSet rs  = null;
		try {
			conn = DriverManager.getConnection(url,    "root","123456");
			//创建一个Statement对象
			stmt = conn.createStatement(); 
			String sql = "select r_name,r_content from tb_rule where r_name = '"+r_name+"'";
			rs = stmt.executeQuery(sql);

			while (rs.next()){
				is = rs.getBinaryStream("r_content");
				if(is!=null){
					ByteArrayInputStream msgContent =(ByteArrayInputStream) is;
					byte[] byte_data = new byte[msgContent.available()];
					msgContent.read(byte_data, 0,byte_data.length);
					result = new String(byte_data);
					//System.out.println(result);
				}
				break;
			}

		} catch (SQLException e){
			e.printStackTrace();
		}finally{
			try{
			if(is!=null)
				is.close();
			if(rs!=null)
				rs.close();
			if(stmt!=null)
				stmt.close();
			if(stmt!=null)
				conn.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return result;
	}
	public static int update(String r_name,String r_content){
		int count = -1;
		try{
			//调用Class.forName()方法加载驱动程序
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("成功加载MySQL驱动！");
		}catch(ClassNotFoundException e1){
			System.out.println("找不到MySQL驱动!");
			e1.printStackTrace();
		}

		String url="jdbc:mysql://localhost:3306/drools";
		Connection conn = null;
		PreparedStatement pstmst = null;
		ByteArrayInputStream stream = null;
		try {
			conn = DriverManager.getConnection(url,    "root","123456");
			//创建一个Statement对象
			//stmt= conn.createStatement(); 
			String sql = "update tb_rule set r_content = ? where r_name = '"+r_name+"' ";
			String sql2 = "insert into tb_rule(r_name,r_content) values('"+r_name+"',?) ";



			System.out.println("sql2="+sql2);
			System.out.println("sql="+sql);
			if(queryOne(r_name)){
				pstmst = conn.prepareStatement(sql);
				stream = new ByteArrayInputStream(r_content.getBytes());
				pstmst.setBinaryStream(1,stream,stream.available());
				count = pstmst.executeUpdate();
			}
			else{
				pstmst = conn.prepareStatement(sql2);
				stream = new ByteArrayInputStream(r_content.getBytes());
				pstmst.setBinaryStream(1,stream,stream.available());
				count = pstmst.executeUpdate();
			}

			/*  ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()){
            	 System.out.print(rs.getString(1) + "\t");
                 System.out.print(rs.getBlob(2) + "\t");
                 System.out.println();
            }
            rs.close();*/

		} catch (SQLException e){
			e.printStackTrace();
		}finally{
			try{

				if(conn!=null)
					conn.close();
				if(stream!=null)
					stream.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return count;
	}
}
