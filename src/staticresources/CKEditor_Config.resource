CKEDITOR.editorConfig = function( config ) {
    config.toolbarGroups = [
        { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
        { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
        { name: 'styles', groups: [ 'styles' ] },
        { name: 'links' }
    ];
    config.removeButtons = 'Underline,Subscript,Superscript,Scayt,Styles,Blockquote,Anchor';
    config.forcePasteAsPlainText = true;
    config.extraPlugins = 'autolink';
};