$(document).ready(function() {
  $('.picth-datepicker').datetimepicker({
    timepicker: false,
    format: 'd-m-Y'
  });
  $('.pitch-timepicker').datetimepicker({
    datepicker: false,
    format:'H:i'
  });
  
  $('.rent-btn').hide();
  $('.view-match-btn').hide();
  $('.check-mini-pitch').on('click', function(){
    $('.rent-btn').hide();
    $('.view-match-btn').hide();
    var start_hour = $('#start_hour').val();
    var end_hour = $('#end_hour').val();
    var date = $('#date').val();
    var mini_pitch_id = $('#mini_pitch_id').val();

    if (!start_hour || !end_hour || !date){
      $('.form-check-result').html('<h3>' + "Nhap cho du te"+ '</h3');
      return false;
    }
    $.ajax({
      url: '/check_mini_pitches/', 
      data: {start_hour: start_hour, end_hour: end_hour, date: date,
        mini_pitch_id: mini_pitch_id}, 
      success: function(data) {
        $('.check-result-text').html('<h3>' + data.flash + '</h3>');
        if(data.status === 102) {
          $('.rent-btn').show();
        }

        if(data.status === 101) {
          $('.view-match-btn').show();
          $('.view-match-btn').attr('href', '/matches/' + data.id);
        }
      },
      error: function(error) {
        $('.form-check-result').html('<h3>' + error + '</h3');
      }
    });
    return false;
  });

  $('.rent-mini-pitch-btn').on('click', function(){
    var start_hour = $('#start_hour').val();
    var end_hour = $('#end_hour').val();
    var date = $('#date').val();
    var mini_pitch_id = $('#mini_pitch_id').val();
    rent = {start_hour: start_hour, end_hour: end_hour, date: date,
        mini_pitch_id: mini_pitch_id}

    $.ajax({
      url: '/rents/',
      method: "POST",
      data: {rent: rent},
      success: function(data) {
        $.growl.notice({message: data['message']});
        window.location.href = '/rents/' + data.id;
      },
      error: function(error) {
        $.growl.error({message: error});
        window.reload();
      }
    });
    return false;
  });

  $('#rent-modal').on('show.bs.modal', function () {
   $('.rent-mini-pitch-start').html($('#start_hour').val())
   $('.rent-mini-pitch-end').html($('#end_hour').val())
   $('.rent-mini-pitch-date').html($('#date').val())
  });

  $('.new-match-btn').on('click', function(){
    var rent_id = $('#rent_id').val();
    var max_quantity = $('#max_quantity').val();
    var quantity = $('#quantity').val();

    if (Number(max_quantity) <= 0 || Number(quantity) > Number(max_quantity)) {
      $.growl.notice({message: "So luong ko hop le"});
    }
    else {
    
      match = {rent_id: rent_id, max_quantity: max_quantity}

      $.ajax({
        url: '/matches/',
        method: "POST",
        data: {match: match, quantity: quantity},
        success: function(data) {
          window.location.href = '/matches/' + data.id;
          $.growl.notice({message: data['message']});
        },
        error: function(error) {
          $.growl.error({message: error});
          window.reload();
        }
      });
    }
    return false;
  });

  $('.confirm-join-match-btn').on('click', function(){
    var match_id = $('#match_id').val();
    var available = $('#available_quantity').val();
    var quantity = $('#quantity').val();

    if (Number(quantity) <= 0 || Number(quantity) > Number(available)) {
      $.growl.notice({message: "So luong ko hop le"});
    }
    else {
    
      match_user = {match_id: match_id, quantity: quantity}

      $.ajax({
        url: '/match_users/',
        method: "POST",
        data: {match_user: match_user},
        error: function(error) {
          $.growl.error({message: error});
          window.reload();
        }
      });
    }
    return false;
  });
});
