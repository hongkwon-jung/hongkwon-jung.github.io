// filter chips (projects / experience) and TOC highlight
(function(){
  var f=document.querySelector('.filters'), cards=document.querySelectorAll('#cards .card');
  if(f){f.addEventListener('click',function(e){var b=e.target.closest('button');if(!b)return;
    f.querySelectorAll('button').forEach(function(x){x.classList.toggle('on',x===b)});
    var k=b.getAttribute('data-f');cards.forEach(function(c){c.hidden=!(k==='all'||c.getAttribute('data-cat')===k)});});}
  var links=document.querySelectorAll('.toc a');
  if(links.length&&'IntersectionObserver' in window){
    var map={};links.forEach(function(a){map[a.getAttribute('href').slice(1)]=a});
    var io=new IntersectionObserver(function(es){es.forEach(function(en){if(en.isIntersecting){
      links.forEach(function(a){a.classList.remove('on')});var a=map[en.target.id];if(a)a.classList.add('on');}})},{rootMargin:'-20% 0px -70% 0px'});
    document.querySelectorAll('.psec').forEach(function(s){io.observe(s)});
  }
  // section rail highlight (v3 project pages)
  var rl=document.querySelectorAll('.vrail a');
  if(rl.length&&'IntersectionObserver' in window){
    var rm={};rl.forEach(function(a){rm[a.getAttribute('href').slice(1)]=a});
    var ro=new IntersectionObserver(function(es){es.forEach(function(en){if(en.isIntersecting){
      rl.forEach(function(a){a.classList.remove('on')});var a=rm[en.target.id];if(a)a.classList.add('on');}})},{rootMargin:'-30% 0px -60% 0px'});
    document.querySelectorAll('.vsec[id]').forEach(function(s){ro.observe(s)});
  }
  // reference filter
  document.querySelectorAll('.reffilter').forEach(function(inp){
    var panel=inp.closest('.tpanel');
    inp.addEventListener('input',function(){var q=inp.value.trim().toLowerCase();
      panel.querySelectorAll('ol.refs li').forEach(function(li){li.hidden=q&&li.textContent.toLowerCase().indexOf(q)<0;});});
  });
  // circuit viewer
  document.querySelectorAll('.cview').forEach(function(cv){
    var btns=[].slice.call(cv.querySelectorAll('.cv-btns button')), views=[].slice.call(cv.querySelectorAll('.cv-view'));
    function show(i){btns.forEach(function(b,j){b.setAttribute('aria-pressed',j===i?'true':'false');});views.forEach(function(v,j){v.hidden=j!==i;});}
    cv.addEventListener('click',function(e){var b=e.target.closest('[data-v]');if(!b||!cv.contains(b))return;var i=+b.getAttribute('data-v');show(i);if(b.classList.contains('cv-hot'))btns[i].focus({preventScroll:true});});
    show(0);
  });
  // project tabs (회로 설계 페이지)
  var tl=document.querySelector('.ptabs');
  if(tl){
    var tabs=[].slice.call(tl.querySelectorAll('[role=tab]'));
    var panels=tabs.map(function(t){return document.getElementById(t.getAttribute('aria-controls'))});
    var anchor=document.querySelector('.tanchor'), bar=document.querySelector('.topbar');
    function toTop(){var off=bar?bar.offsetHeight:0;if(anchor.getBoundingClientRect().top<off){var y=anchor.getBoundingClientRect().top+window.pageYOffset-off;try{window.scrollTo({top:y,behavior:'instant'});}catch(err){window.scrollTo(0,y);}}}
    function act(i,opt){opt=opt||{};
      tabs.forEach(function(t,j){var on=j===i;t.setAttribute('aria-selected',on?'true':'false');t.tabIndex=on?0:-1;panels[j].hidden=!on;});
      if(opt.focus)tabs[i].focus();
      if(opt.hash)history.replaceState(null,'',i===0?location.pathname+location.search:'#'+panels[i].id);
      toTop();}
    function idx(id){for(var k=0;k<panels.length;k++){if(panels[k].id===id)return k;}return -1;}
    tl.addEventListener('click',function(e){var b=e.target.closest('[role=tab]');if(!b)return;act(tabs.indexOf(b),{hash:true});});
    tl.addEventListener('keydown',function(e){var i=tabs.indexOf(document.activeElement);if(i<0)return;var n=null;
      if(e.key==='ArrowRight')n=(i+1)%tabs.length;else if(e.key==='ArrowLeft')n=(i-1+tabs.length)%tabs.length;
      else if(e.key==='Home')n=0;else if(e.key==='End')n=tabs.length-1;
      if(n!==null){e.preventDefault();act(n,{focus:true,hash:true});}});
    document.addEventListener('click',function(e){var a=e.target.closest('a[href^="#"]');if(!a)return;var k=idx(a.getAttribute('href').slice(1));
      if(k<0)return;e.preventDefault();act(k,{hash:true});});
    window.addEventListener('hashchange',function(){var k=idx(location.hash.slice(1));if(k>=0)act(k);});
    var k0=idx(location.hash.slice(1));act(k0>=0?k0:0);
    if(k0>=0)window.addEventListener('load',function(){setTimeout(toTop,0);});
  }
})();
