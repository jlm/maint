$newuser = User.new({email: 'superadmin@cuthberts.org', password: 'elephant', password_confirmation: 'elephant',
                    admin: true, debugger: true})
$newuser.skip_confirmation!
$newuser.save
$newuser.errors
