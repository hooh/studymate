package com.studyMate.world.screens.wordcards
{
	import com.studyMate.utils.BitmapFontUtils;
	
	import de.polygonal.core.ObjectPool;
	
	public class RememberCardPool extends ObjectPool
	{
		private var cardFactory:RememberCardFactory;
		
		
		
		public function RememberCardPool(grow:Boolean=true)
		{
			cardFactory = new RememberCardFactory(BitmapFontUtils.getTexture("bg_00000"));
			super(grow);
			setFactory(cardFactory);
			allocate(100);
		}
		
	}
}


import com.studyMate.world.screens.component.WordCard;

import de.polygonal.core.ObjectPoolFactory;

import starling.textures.Texture;

internal class RememberCardFactory implements ObjectPoolFactory
{
	private var texture:Texture;
	public function RememberCardFactory(_texture:Texture)
	{
		this.texture = _texture;
	}
	
	public function create():*
	{
		var word:WordCard = new WordCard(texture);
		return word;
	}
}