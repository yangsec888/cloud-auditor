//Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready(function() {
  $("#jstree_yml_files").jstree({
    'core': {
      'data': {
        'url': '/yml_settings/index.json',
        'dataType': 'json'
      },
      'themes' : {
        "variant" : "large",
        //"url" : "/assets/jstree.css"
      }
    },
    'types': {
            'default': {
                'icon': "glyphicon glyphicon-flash"
            },
    },
 //    "plugins" : [ "search" ]
    'plugins' : ["themes", "json_data", "sort", "changed", "types", "wholerow"]
  });

  var editor = CodeMirror(document.getElementById("myTextArea"), {
    mode: "yaml",
    lineNumbers: true,
    extraKeys: {"Ctrl-Space": "autocomplete"},
    value: 'Please select configuration file from the tree left.'
  });

  $('#jstree_yml_files').on('changed.jstree', function(e, data) {
   var node = data.instance.get_node(data.selected[0]);
   if (node.id.includes('.yml')) {
     $('#save_button').show();
     $('#file_path').val(node.id);
     $.ajax({
       url: "load_file",
       type: "GET",
       dataType: 'text',
       data: {'path': node.id},
       success:function(response){
         //console.log(response);
         editor.getDoc().setValue(response);
       }});
     }
   }).jstree({
     'core': {
       'data': {
         'url': '/yml_settings/index.json',
         'dataType': 'json'
       },
       'themes' : {
         "variant" : "large",
         //"url" : "/assets/jstree.css"
       }
     },
     'types': {
             'default': {
                 'icon': "glyphicon glyphicon-flash"
             },
     },
  //    "plugins" : [ "search" ]
     'plugins' : ["themes", "json_data", "sort", "changed", "types", "wholerow"]
   });


  $('#save_button').click(function() {
    $.ajax({
      url: "save_file",
      type: "POST",
      dataType: 'json',
      data: {'file_path': $('#file_path').val(), 'file_content': editor.getDoc().getValue()},
      success: function(response){
        //console.log(response);
        alert(response['message'])
      }
    });
  });

});
