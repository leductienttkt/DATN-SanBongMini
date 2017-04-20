$(document).ready(function() {
  $('.picth-datepicker').datetimepicker({
    timepicker: false,
    format: 'd/m/Y'
  });
  $('.pitch-timepicker').datetimepicker({
    datepicker: false,
    format:'H:i'
  });
  
  $('.rent-btn').hide();
  $('.check-mini-pitch').on('click', function(){
    $('.rent-btn').hide();
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
        if(data.status === 101) {
          $('.rent-btn').show();
        }
      },
      error: function(error) {
        $('.form-check-result').html('<h3>' + error + '</h3');
      }
    });
    return false;
  });

  $('#rent-modal').on('show.bs.modal', function () {
   $('.modal-body').html($('#start_hour').val())
  });
});
