(function(){ 
  'use strict';
  
  new Sketch($('#canvas-wrap'), 'https://qwel.design/ac/'); 
  new Router({
    ruteDir: 'https://qwel.design/ac/'
  });
  new Slidemenu();
  
})();