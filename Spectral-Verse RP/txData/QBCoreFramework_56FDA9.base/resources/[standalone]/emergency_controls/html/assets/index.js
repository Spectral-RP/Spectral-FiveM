const resource = GetParentResourceName()

document.onkeydown = function (data) {
	if (data.which == '314' || '27') {
		$('#container').fadeOut(250)
		$.post(`https://${resource}/close`, JSON.stringify({ }))
	}
}


$(document).ready(function() {
    $.post(`https://${resource}/nuiReady`, JSON.stringify({ }))
});

window.addEventListener('message', function(event) {
	if (event.data.type === "showHud") {
		if (event.data.mode === 1) {
			$('#chirpOn').show()
			$('#chirpOff').hide()
		} else {
			$('#chirpOff').show()
			$('#chirpOn').hide()			
		}

		$('#sirenThreeOff').show()
		$('#sirenThreeOn').hide()
		$('#sirenOneOff').show()
		$('#sirenOneOn').hide()
		$('#sirenTwoOff').show()
		$('#sirenTwoOn').hide()
		$('#control_hud').fadeIn(250)
	} else if (event.data.type === "hideHud") {
		$('#control_hud').fadeOut(250)
	} else if (event.data.type === "open") {
		$('#container').fadeIn(250)
	} else if (event.data.type === "close") {
		$('#container').fadeOut(250)
	} else if (event.data.type === "initData") {
		let sirens = event.data.sirens

		for (let i=1; i < sirens.length+1; i++) {
			let count = i
			count--

			$('#SirenOne').append(`<option value="${i}">${sirens[count]}</option>`)
			$('#SirenTwo').append(`<option value="${i}">${sirens[count]}</option>`)
			$('#SirenThree').append(`<option value="${i}">${sirens[count]}</option>`)
			$('#SirenFour').append(`<option value="${i}">${sirens[count]}</option>`)
		}
	} else if (event.data.type === "changeState") {
		if (event.data.category === "sirenOne") {
			if (event.data.value === true) {
				$('#sirenOneOn').show()
				$('#sirenOneOff').hide()
			} else {
				$('#sirenOneOff').show()
				$('#sirenOneOn').hide()
			}
		} else if (event.data.category === "sirenTwo") {
			if (event.data.value === true) {
				$('#sirenTwoOn').show()
				$('#sirenTwoOff').hide()
			} else {
				$('#sirenTwoOff').show()
				$('#sirenTwoOn').hide()
			}
		} else if (event.data.category === "sirenThree") {
			if (event.data.value === true) {
				$('#sirenThreeOn').show()
				$('#sirenThreeOff').hide()
			} else {
				$('#sirenThreeOff').show()
				$('#sirenThreeOn').hide()
			}
		} else if (event.data.category === "chirpMode") {
			if (event.data.value === true) {
				$('#chirpOn').show()
				$('#chirpOff').hide()
			} else {
				$('#chirpOff').show()
				$('#chirpOn').hide()
			}		
		}
	}
})

$('body').on('click', '.save', function(event) {
	let sirenOne = $('#SirenOne').val()
	let sirenTwo = $('#SirenTwo').val()
	let sirenThree = $('#SirenThree').val()
	let sirenFour = $('#SirenFour').val()

	$.post(`https://${resource}/saveOverrides`, JSON.stringify({ sirenOne: sirenOne, sirenTwo: sirenTwo, sirenThree: sirenThree, sirenFour: sirenFour }))
	$('#container').fadeOut(250)
})

function myFunction(value) {
	$('#SirenOne').append(`<option value="${value}">${value}</option>`)
}