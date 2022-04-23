var Config = {
	
	server_name: 'Spectral-Verse',
	pause_after_intro: 3000,
	bg_video: 'SefG0gfxK6s', // https://www.youtube.com/watch?v=Wqsg2vWHZBM

	radio_volume: 0.05,
	radio_playlist: [
        {name: 'Frigga - Hit Me', link:'custom_data/HitMe_Frigga.mp3' }, // STREAM
        {name: 'Frigga - Hit Me', link:'custom_data/HitMe_Frigga.mp3' } // patch
    ],
	
	main_menu: [
		{caption: 'HOME', onclick: LS.home.show},
		{caption: 'NEWS', onclick: LS.news.show},
		{caption: 'RULES', onclick: LS.rules.show},
		{caption: 'CONTACTS', onclick: LS.contacts.show},
	],
	
	assets :
	{
		bad_tv: './assets/bad_tv.mp4',
	},
};