package com.studyMate.world.component.sysface
{
	import feathers.controls.ScrollText;

	public class ScrollTextExtends extends ScrollText
	{
		public var textViewPort1:TextFieldViewPortExtends;
		public function ScrollTextExtends()
		{
			super();
			this.textViewPort1 = new TextFieldViewPortExtends;
			this.viewPort = textViewPort1;;
		}
		
		override protected function draw():void
		{
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const scrollInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SCROLL);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			
			if(dataInvalid)
			{
				this.textViewPort1.text = this._text;
				this.textViewPort1.isHTML = this._isHTML;
			}
			
			if(stylesInvalid)
			{
				this.textViewPort1.antiAliasType = this.antiAliasType;
				this.textViewPort1.background = this.background;
				this.textViewPort1.backgroundColor = this.backgroundColor;
				this.textViewPort1.border = this.border;
				this.textViewPort1.borderColor = this.borderColor;
				this.textViewPort1.condenseWhite = this.condenseWhite;
				this.textViewPort1.displayAsPassword = this.displayAsPassword;
				this.textViewPort1.gridFitType = this.gridFitType;
				this.textViewPort1.sharpness = this.sharpness;
				this.textViewPort1.thickness = this.thickness;
				this.textViewPort1.textFormat = this._textFormat;
				this.textViewPort1.styleSheet = this._styleSheet;
				this.textViewPort1.embedFonts = this._embedFonts;
				this.textViewPort1.paddingTop = this._textPaddingTop;
				this.textViewPort1.paddingRight = this._textPaddingRight;
				this.textViewPort1.paddingBottom = this._textPaddingBottom;
				this.textViewPort1.paddingLeft = this._textPaddingLeft;
				this.textViewPort1.visible = this._visible;
				this.textViewPort1.alpha = this._alpha;
			}
			super.draw();
		}
	}
}