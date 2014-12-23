package com.mylib.framework.model
{
	
	import com.studyMate.global.Global;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class HTMLParseProxy extends Proxy implements IProxy
	{
		public function HTMLParseProxy()
		{
			super();
		}
		
		public function getHtmlBody(html:XML):String{
			var result:String = html.body[0];
			result = formatHtml(result);
			return result.substring(6,result.length-7);
		}
		
		public function getHtmlHeadLink(html:XML):String{
			var result:String = html.head.link.toXMLString()+html.head.style.toXMLString();
			result = formatHtml(result);
			return result;
		}
		
		public function getHtml(path:String):XML{
			var file:File = Global.document.resolvePath(Global.localPath+"html/"+path);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ);
			var str:String = fileStream.readMultiByte(fileStream.bytesAvailable,"utf-8");
			var html:XML = XML(str);
			
			return html;
		}
		
		private function formatHtml(input:String):String{
			return input.replace( new RegExp( "\\n", "g" ), "" ).replace( new RegExp( "\\r", "g" ), "" ).replace( new RegExp( "\\t", "g" ), "" ).replace( new RegExp( "\"", "g" ), "\\\"" ).replace( new RegExp( "'", "g" ), "&acute;" );
		}
		
		
	}
}