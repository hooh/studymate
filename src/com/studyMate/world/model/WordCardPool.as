package com.studyMate.world.model
{
	import com.studyMate.utils.BitmapFontUtils;
	
	import de.polygonal.core.ObjectPool;
	
	public class WordCardPool extends ObjectPool
	{
		private var cardFactory:WordCardFactory;
		
		
		
		public function WordCardPool(grow:Boolean=false)
		{
			cardFactory = new WordCardFactory(BitmapFontUtils.getTexture("bg_00000"));
			super(grow);
			setFactory(cardFactory);
			allocate(100);
		}
		
	}
}


import com.studyMate.world.screens.component.WordCard;

import de.polygonal.core.ObjectPoolFactory;

import starling.textures.Texture;

internal class WordCardFactory implements ObjectPoolFactory
{
	private var texture:Texture;
	public function WordCardFactory(_texture:Texture)
	{
		this.texture = _texture;
	}
	
	public function create():*
	{
		var word:WordCard = new WordCard(texture);
		return word;
	}
}