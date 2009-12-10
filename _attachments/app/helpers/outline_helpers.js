var OutlineHelpers = {
  bindSubmitOnBlurAndAutogrow: function(){
    $('textarea.expanding').autogrow();
    $('textarea.expanding').bind('blur', function(e){
      note = new NoteElement($(e.target));
      note.unfocusTextarea();
      note.submitIfChanged();
    });
  },
  
  getOutlineId: function(){
    return this.$element().find('h2#outline-id').html();
  },
  
  renderOutline: function(context, view, notes){
    context.render('show', view, function(response){
      context.app.swap(response);
      first_note = new NoteElement($('ul#notes li:first').find('textarea.expanding'));
      if(notes.notes.length > 1) {
        first_note.renderNotes(context, notes); 
      }
      first_note.focusTextarea();
      context.bindSubmitOnBlurAndAutogrow();
      $('#spinner').hide(); 
    });     
  },
  
  replicateUp: function(){
    var context = this;
    $.post(context.localServer()+ '/_replicate', 
      '{"source":"' + context.db() + '", "target":"' + context.server() + '/' + context.db()+ '", "continuous":true}',
      function(){},"json");
  },
  
  replicateDown: function(){
    var context = this;
    $.post(context.localServer()+ '/_replicate', 
      '{"source":"' + context.server() + '/' + context.db() + '", "target":"' + context.db() + '", "continuous":true}',
      function(){},"json");
  }, 
  
  db: function(){
    return "doingnotes"
  },
  
  server: function(){
    return "http://localhost:" + this.serverPort();
  },
  
  localServer: function(){
    return "http://localhost:" + this.localPort();
  },
  
  localPort: function(){
    return window.location.port;
  },
  
  serverPort: function(){
    if(window.location.port == "5984") return "5986"
    else return "5984"
  }
}