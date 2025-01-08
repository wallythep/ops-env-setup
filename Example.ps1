# We need to invoke the function module
# In this example, we assume the module is located in the same 
# directory as the dev ops scripts.
# But you may put this in a central location or invoke it in your
# powershell profile for permanent access.
. .\Setup-Env.ps1

# Now set up your environment variables
# Here, obviously, you change the names to reflect your situation.
# But these are only names (not values), so it is safe to put this in source control.
# Copy and paste as needed.
Set-EnvironmentSecret -VaultName "test-devops-rg-kv-wlp" -SecretName "test-kv-secret-1" -EnvironmentVariable TEST_1

# Now we can invoke our code to do the devops set up, 
# and the environment will be set up


# Finally, clear the environment variables.
# Not necessary all the time, especially if you are testing the resource set up,
# but on a machine that allows access, probably a good idea.
# WARNING: this doesn't check that this is _your_ variable to clear.
# WARNING: you could be clearing a significant shell variable instead.
# Copy and paste as needed.
Clear-EnvironmentSecret -EnvironmentVariable TEST_1