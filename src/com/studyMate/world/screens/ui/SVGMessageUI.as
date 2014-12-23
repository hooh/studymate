package com.studyMate.world.screens.ui
{
	import com.greensock.TweenLite;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.display.SVGText;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	import com.mylib.framework.CoreConst;
	import com.studyMate.global.Global;
	import com.studyMate.model.vo.ToastVO;
	import com.studyMate.world.component.SVGEditor.utils.SVGMessageTextDrawer;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import feathers.controls.Scroller;
	import feathers.controls.supportClasses.LayoutViewPort;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class SVGMessageUI extends Sprite
	{
		private var _svgDocument:SVGDocument;
		private var _webView:StageWebView 
		
		private var textureList:Vector.<Texture>;
		
		private var scroll:Scroller;
		private var viewPort:LayoutViewPort;
		
		public function SVGMessageUI()
		{									
			scroll = new Scroller();			
			scroll.x = 0;
			scroll.y = 0;
			scroll.width = 135;
			scroll.height = 428;
						
			viewPort = new LayoutViewPort();
			scroll.viewPort = viewPort;
			addChild(scroll);
		}
		
		private function get svgDocument():SVGDocument{
			if(_svgDocument==null){				
				ProcessExecutor.instance.initialize(Global.stage);
				_svgDocument = new SVGDocument();
				_svgDocument.x = 200;			
				_svgDocument.textDrawer = new SVGMessageTextDrawer();
				_svgDocument.useEmbeddedFonts = true;
				_svgDocument.defaultFontName = "HeiTi";
				_svgDocument.validateWhileParsing = false;											
				_svgDocument.addElement(new SVGText);
				_svgDocument.addEventListener(SVGEvent.RENDERED,svgRENDEREDComplete);
			}
			return _svgDocument;
		}
		
		private function get webView():StageWebView{
			if(_webView==null){
				_webView = new StageWebView();
				_webView.stage = Global.stage;
				var result:Point = new Point();
				this.localToGlobal(new Point(0,0),result);
				_webView.viewPort = new Rectangle(result.x, result.y, scroll.width+4,scroll.height);
			}
			return _webView;
		}
		
		//显示svg信息
		public function showSVGMessage(str:String):void{
			try{
				var xml:XML = new XML(str);
				xml.prependChild(<text  x="0" y="0">`</text>);
				svgDocument.clear();
				svgDocument.parse(xml);					
			}catch(e:Error){
				Facade.getInstance(CoreConst.CORE).sendNotification(CoreConst.TOAST,new ToastVO("抱歉，邮件格式有误...",2));				
			}
		}
		//显示html信息
		public function showHtmlMessage(str:String):void{	
			if(str.indexOf('<style')==-1){
				str = str.replace('</head>','<style type="text/css">body {background-color: #EEE2C6;}</style></head>')
			}else{
				if(str.indexOf('background-color')!=-1){					
					str = str.replace(/background\-color/,"background-color: #EEE2C6;");
				}else{
					str = str.replace('</style>','body {background-color: #EEE2C6;}</style>')
				}
			}
			webView.stage = Global.stage;
			webView.loadString(str); 
		}
		
		override public function set visible(value:Boolean):void
		{
			if(_webView){
				try{					
					//取stage可能会引发异常，ArgumentError: Error #2004: One of the parameters is invalid.
					_webView.stage = null;
				}catch(e:Error){
					trace("SVGMessageUI visible",e.message);
				}
			}
			super.visible = value;
		}
		
		
		
		public function set showWidth(width:Number):void{
			scroll.width = width;
		}
		public function set showHeight(height:Number):void{
			scroll.height = height;
		}
		
		protected function svgRENDEREDComplete(event:SVGEvent):void
		{
			this.clearTexture();
			viewPort.removeChildren(0,-1,true);
			textureList = new Vector.<Texture>;
			var texture:Texture;
			if(svgDocument.height<2048){	
				var bmd:BitmapData;
				bmd = new BitmapData(svgDocument.width,svgDocument.height,true,0);
				bmd.draw(svgDocument);
				texture = Texture.fromBitmapData(bmd,false);
				img = new Image(texture);	
				textureList.push(texture);
				viewPort.addChild(img);
			}else{
				var total:int = Math.ceil(svgDocument.height/1024);
				for(var i:int=0;i<total;i++){					
					var height:Number=1024;
					if(i<total-1){
						height=1024
					}else{
						height = svgDocument.height-i*1024;
					}
					if(height<1) height = 1;
					var bmd2:BitmapData = new BitmapData(svgDocument.width,height,true,0);
					var matrix:Matrix = new Matrix(1,0,0,1,0,-i*1024);
					bmd2.draw(svgDocument,matrix);
					texture = Texture.fromBitmapData(bmd2,false);		
					var img:Image =  new Image(texture);
					textureList.push(texture);
					img.y += i*1024;
					viewPort.addChild(img);
				}
			}
		}
		
		/*private function toChangeToGpu():void{
			
		}*/
		
		private function clearTexture():void{
			if(textureList){
				for(var i:int=0;i<textureList.length;i++){
					textureList[i].dispose();
				}
				textureList.length = 0 ;
				textureList = null;
			}
		}
		
		override public function dispose():void
		{
			this.clearTexture();
			if(_webView){
				_webView.stage = null;
				_webView.dispose();
			}
			if(_svgDocument){
				_svgDocument.clear();
			}
			super.dispose();
		}
		
		
	}
}