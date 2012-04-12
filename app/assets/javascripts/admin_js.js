/**
 * Created by JetBrains RubyMine.
 * User: serg
 * Date: 10.03.12
 * Time: 16:34
 * To change this template use File | Settings | File Templates.
 */

function generate_login_with_id( id_of_element_to_insert ) {
	var log = "schoolh_";
	var randomstring = generate_random_string( 5 );		
 	document.getElementById( id_of_element_to_insert ).value = log + randomstring;
}

function generate_password_with_id( id_of_element_to_insert ) {
	var randomstring = generate_random_string( 15 );		
	document.getElementById( id_of_element_to_insert ).value = randomstring;
}

function generate_login() {
	var log = "schoolh_";
	var randomstring = generate_random_string( 5 );		
 	document.getElementById('user_user_login').value = log + randomstring;
}

function generate_password() {
	var randomstring = generate_random_string( 15 );		
	document.getElementById('user_password').value = randomstring;
}

function generate_random_string( string_length ) {
	var log = "schoolh_";
	var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
	var randomstring = '';

	if (string_length > 0) 
	{
		for (var i=0; i<string_length; i++) {
			var rnum = Math.floor(Math.random() * chars.length);
			randomstring += chars.substring(rnum, rnum+1);
		}

		return randomstring;
	} 
	else
	{
		return null;
	};
}

