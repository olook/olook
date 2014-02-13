$(document).ready( function() { 
	$('#sortable_images').sortable({
		axis: 'y',
		dropOnEmpty: false,
		handle: '.handle',
		cursor: 'move',
		items: 'tr',
		opacity: 0.4,
		scroll: true,
		update: function(){
			$.ajax({
				type: 'post',
				data: $('#sortable_images').sortable('serialize'),
				dataType: 'script',
				complete: function(request){
					$('#sortable_images').effect('highlight');
				},
				url: '/admin/products/' + $('#sortable_images').data('productId') + '/sort_pictures'
			})
		}
	})

});
