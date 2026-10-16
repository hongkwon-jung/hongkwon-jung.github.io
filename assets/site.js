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
})();
