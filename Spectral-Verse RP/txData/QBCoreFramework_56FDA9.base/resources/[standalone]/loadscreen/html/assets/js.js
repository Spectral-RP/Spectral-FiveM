/*
	Developed by Lucky
	https://sergey-lucky.tebex.io/
*/

"use strict";

var LS = {

	start: function()
	{
		body.innerHTML = LS.main.wrap_tmp();
		
		//LS.main.start();
		LS.intro.after = LS.main.start;
		LS.intro.start();

		window.addEventListener('message', function(e)
		{
			(LS.uploader.handlers[e.data.eventName] || function() { })(e.data);
		});
	},
};

LS.main = {
	
	start: function()
	{
		main_wrap.innerHTML = LS.main.tmp(
									LS.menu.logo_tmp(),
									LS.menu.items_tmp(Config.main_menu),
									LS.radio.player_tmp(),
									LS.uploader.tmp()
								);

		if(typeof background_video !== 'undefined')
			background_video.className = 'background-video';
		
		LS.radio.mute(false);
		LS.menu.onClick(0);
		let fw = menu.offsetHeight;
		menu.className = 'menu-wrap menu-wrap-opened';
	},
	
	tmp: function(logo_html, menu_html, player_html, uploader_html)
	{
		return `	<div id="menu" class="menu-wrap">${logo_html}${menu_html}${player_html}</div>
				<div id="content_wrap" class="content-wrap"></div>
				<div id="uploader_wrap" class="uploader-wrap">${uploader_html}</div>
				<div id="cursor" class="cursor"></div>
				`;
	},
	
	wrap_tmp: function()
	{
		let vl = `https://www.youtube.com/embed/${Config.bg_video}?autoplay=1&amp;showinfo=0&amp;controls=0&amp;loop=1&amp;playsinline=1&amp;mute=1&amp;rel=0&amp;playlist=${Config.bg_video}`;
		return `	<iframe id="background_video" class="background-video background-video-hide" src="${vl}" frameborder="0" allow="autoplay" allowfullscreen=""></iframe>
				<div id="main_wrap" class="main-wrap" onmousemove="LS.cursor.onMouseMove(event)"></div>`;
	},
	
	content_tmp: function(header, content)
	{
		return `<div class="content-header">${header}</div><div class="content-items-wrap custom-slider">${content}</div>`;
	},
	
	contentHideAnimate: function(after)
	{
		content_wrap.className = 'content-wrap';		
		setTimeout(after, 700);
	},
	
	contentShowAnimate: function()
	{
		content_wrap.className = 'content-wrap content-wrap-opened';
	}
};

LS.cursor = {
	
	onMouseMove: function(event)
	{
		// console.log(event.clientX event.clientY);
		cursor.style.left = event.clientX + 'px';
		cursor.style.top = event.clientY + 'px';
	}
};

LS.uploader = {
	
	progress: 0,
	count: 0,
	thisCount: 0,
	
	handlers: {
		
		startInitFunctionOrder(data) 
		{
			LS.uploader.count = data.count;
		},
		
		initFunctionInvoking(data) 
		{
			let localdata = ((data.idx / LS.uploader.count) * 100);
			LS.uploader.updateProgress(localdata);
		},
		
		startDataFileEntries(data) 
		{
			LS.uploader.count = data.count;
		},
		
		performMapLoadFunction(data) 
		{
			++LS.uploader.thisCount;
			let localdata = ((LS.uploader.thisCount / LS.uploader.count) * 100);
			LS.uploader.updateProgress(localdata);
		}
	},
	
	updateProgress: function(progress)
	{
		if(progress > LS.uploader.progress)
		{
			uploader_line.style.width = progress + '%';
			LS.uploader.progress = progress;
		}
	},
	
	tmp: function()
	{
		return `<div id="uploader_line" class="uploader-line"></div>`;
	},	
};

LS.menu = {
	
	selecteds: [],
	selected: -1,
	
	onClick: function(select)
	{
		if(LS.menu.selecteds[select])
			throw 'selected';
		
		LS.menu.selected = select;
			
		LS.menu.selecteds.forEach(function(item, i)
		{
			window['menu_item_' + i].className = i == select ? 'menu-item-wrap menu-wrap-selected' : 'menu-item-wrap';
			LS.menu.selecteds[i] = i == select ? true : false;
		});
		
		LS.main.contentHideAnimate(function()
		{
			Config.main_menu[select].onclick();
			LS.main.contentShowAnimate();			
		});
	},
	
	logo_tmp: function()
	{
		return `<div class="menu-logo-wrap"><div class="menu-logo"></div></div><div class="menu-server-name">${Config.server_name}</div>`;
	},
	
	items_tmp: function(items)
	{
		var html = '';
		
		items.forEach(function(item, i)
		{
			LS.menu.selecteds[i] = i == LS.menu.selected ? true : false;
			let selected = LS.menu.selecteds[i] ? ' menu-wrap-selected' : '';
				
			html += `<div class="menu-item-wrap${selected}" id="menu_item_${i}" onclick="LS.menu.onClick(${i});"><div class="menu-item">${item.caption}</div></div>`;
		});
		
		return html;
	},
};

LS.radio = {
	
	muted: true,
	playlist_pointer: 0,
	
	onVolumeChange: function()
	{
		Config.radio_volume = radio_volume.value;
		
		if(Config.radio_volume > 0 && LS.radio.muted)
			LS.radio.mute(false);
		
		if(Config.radio_volume == 0 && !LS.radio.muted)
			LS.radio.mute(true);

		radio.volume = Config.radio_volume;
		radio_volume_range.style.width = radio.volume * 100 + '%';
		LS.radio.play();
	},
	
	onMuteClick: function()
	{
		LS.radio.mute(!LS.radio.muted);
	},
	
	onSelectorClick: function()
	{
		radio.pause();
		
		if(LS.radio.muted)
			LS.radio.mute(false);
		else
			LS.radio.play();
	},
	
	mute: function(mute)
	{
		LS.radio.muted = mute;
		
		if(LS.radio.muted)
		{
			radio.volume = 0;
			radio_volume.value = 0;
			radio_eq.style.opacity = 0;
			radio_name.style.opacity = 0;
			radio_speaker.className = 'radio-speaker-muted';
		}
		else
		{
			Config.radio_volume = Config.radio_volume == 0 ? 0.05 : Config.radio_volume;
			radio_volume.value = Config.radio_volume;
			radio.volume = Config.radio_volume;
			radio_eq.style.opacity = 1;
			radio_name.style.opacity = 1;
			radio_speaker.className = 'radio-speaker';
			LS.radio.play();
		}
		
		radio_volume_range.style.width = radio.volume * 100 + '%';
	},
	
	play: function()
	{
		if(!(radio.duration > 0 && !radio.paused))
		{
			let stream = Config.radio_playlist[LS.radio.playlist_pointer];
			radio.src = stream.link;
			radio_name.innerHTML = stream.name;
			radio.volume = Config.radio_volume;
			radio_volume_range.style.width = radio.volume * 100 + '%';
			radio.play();
			
			LS.radio.playlist_pointer++;
			if(LS.radio.playlist_pointer > Config.radio_playlist.length - 1)
				LS.radio.playlist_pointer = 0;
		}
	},
	
	player_tmp: function()
	{
		return `
				<div id="radio_eq" class="radio-eq"></div>
				<div class="radio-volume-wrap">
					<div id="radio_speaker" onclick="LS.radio.onMuteClick()" class="radio-speaker-muted"></div>
					<div class="radio-volume-range-wrap">
						<input id="radio_volume" class="radio-volume" type="range" min="0" max="1" step=".05" value="0" oninput="LS.radio.onVolumeChange()" onchange="LS.radio.onVolumeChange()">
						<div id="radio_volume_range" class="radio-volume-range"></div>
					</div>
					<div class="radio-selector" onclick="LS.radio.onSelectorClick()"></div>
				</div>
				<div id="radio_name" class="radio-name"></div>
				<audio id="radio"></audio>`;
	}
};

LS.contacts = {
	
	images_path: './custom_data/',
	avatar_default: 'avatar-default.png',
	
	show: function()
	{
		let caption = Config.main_menu[LS.menu.selected].caption;
		let html = LS.contacts.items_tmp(Contacts.contacts);
		
		content_wrap.innerHTML = LS.main.content_tmp(caption, html);
	},
	
	items_tmp: function(items)
	{
		var html = `<div class="contacts-wrap">`;
		
		items.forEach(function(item, i)
		{
			let avatar = item.avatar.trim() == '' ? LS.contacts.avatar_default : item.avatar.trim();
				
			html += `<div class="contacts-item">
							<div class="contacts-title">${item.title}</div>
							<div class="contacts-status">${item.status}</div>
							<div class="contacts-avatar" style="background-image: url(${LS.contacts.images_path}${avatar})"></div>
							<div class="contacts-description">${item.description}</div>
					</div>`;
		});
		
		html += `<div class="bottom-break"></div></div>`;
		
		return html;
	}
};

LS.home = {
	
	show: function()
	{
		content_wrap.innerHTML = LS.home.tmp(Home);
	},
	
	tmp: function(html)
	{
		let fhtml = html.replace('{{server_name}}', Config.server_name);
		return `<div class="home-wrap-0"><div class="home-wrap-1"><div class="home-wrap-2">${fhtml}</div></div></div>`;
	}
};

LS.news = {
	
	images_path: './custom_data/',

	show: function()
	{
		let caption = Config.main_menu[LS.menu.selected].caption;
		let html = LS.news.items_tmp(News.contents);
		
		content_wrap.innerHTML = LS.main.content_tmp(caption, html);
	},
	
	items_tmp: function(items)
	{
		var html = '';
		
		items.forEach(function(item, i)
		{
			let img = item.img.trim() == '' ? '' : `<img class="news-img" src="${LS.news.images_path}${item.img}">`; 
				
			html += `<div class="news-item">
						<div class="news-header">
							<div class="news-title">${item.title}</div>
							<div class="news-data">${item.data}</div>
						</div>
						<div class="news-text">${img}${item.text}</div>
					<div class="news-item-end"></div>
					</div>`;
		});
		
		html += `<div class="bottom-break"></div>`;
		
		return html;
	}
};

LS.rules = {
	
	show: function()
	{
		let caption = Config.main_menu[LS.menu.selected].caption;
		let html = LS.rules.items_tmp(Rules.contents);
		
		content_wrap.innerHTML = LS.main.content_tmp(caption, html);
	},
	
	items_tmp: function(items)
	{
		var html = '';
		
		items.forEach(function(rules)
		{
			html += `<div class="rules-item"><div class="rules-title">${rules.title}</div>`;
			
			rules.texts.forEach(function(item)
			{
				html += `<div class="rules-text">${item.text}</div>`;
			});
			
			html += `</div>`;
		});
		
		html += `<div class="bottom-break"></div>`;
		
		return html;
	}
};

LS.intro = {
	
	start: function()
	{
		main_wrap.innerHTML = LS.intro.tmp();
		let fh = intro_logo.offsetHeight;
		
		setTimeout(function()
		{
			intro_logo.className = 'intro-logo intro-logo-show';
			
			setTimeout(function()
			{
				LS.intro.after();
			}, Config.pause_after_intro + 1500);
		}, 1000);
		
	},
	
	tmp: function()
	{
		return `	<div id="intro_logo" class="intro-logo">
					<div class="intro-hor-pad"></div>
					<div class="intro-logo-wrap-1">
						<div class="intro-hor-wpad">	</div>
						<div class="intro-logo-wrap-2">
							<div class="intro-hor-pad intro-class-3"></div>
								<div class="intro-logo-wrap-3">
									<div class="intro-hor-wpad intro-class-1"></div>
									<div class="intro-logo-wrap-4 intro-logo-main"></div>
									<div class="intro-hor-wpad intro-class-2"></div>
								</div>
							<div class="intro-hor-pad intro-class-4"></div>						
						</div>
						<div class="intro-hor-wpad"></div>
					</div>
					<div class="intro-hor-pad"></div>
				</div>`;
	}
};
