Creating SSH keys for GitHub and Bitbucket

1. Open terminal change directory to .ssh

         cd ~/.ssh

     If you're on Windows, open Git bash and type the above command would open the path

         C:\Users\<user_name>\.ssh

     If you're on Mac or Linux, it would open the .ssh directory in the user's home path.

2. Generate SSH key by issuing the following command.

         ssh-keygen -t ed25519 -C "yourgit@email.com" -f id_file_name
 
      Here, the -f paramter creates 2 files with the name you mentioned. 1 is the private key and another one is the public key.
      

         id_file_name
         id_file_name.pub
         
         
        -C adds a comment into the public key generated. Which is your email ID in this case.

3. Create a config file inside the .ssh directory and tell the Git host address, git user, and SSH key to be used while accessing the Git services.

         touch config
 
 
4. Open the config file in your favorite text editor and add the following lines.

              # Github configuration

               Host user-github
                        HostName github.com
                        User git
                        IdentityFile ~/.ssh/id_file_name_for_github

              # Bitbucket configuration

               Host user-bitbucket
                        HostName bitbucket.org
                        User git
                        IdentityFile ~/.ssh/id_file_name_for_bitbucket
                        
                        
          Save and exit from the editor.
          

5. Copy the id_file_name.pub file content and paste it to your Github account.

        For Github, follow the link https://github.com/settings/keys

        Bitbucket, https://bitbucket.org/account/settings/ssh-keys/

6. Test newly added SSH configuration.

         ssh -T git@user-github
         
7. If you don't get any error from the above command, the authentication worked. Now, you are good to use SSH tunnel to git operation.

8. While cloning the new repo, use the following URL pattern

         git@user-github:some_user_name/project_repo.git
         
Note: If you receive an error like "Host key verification failed", run below command to get rid off.

        ssh-keygn -f "/home/<user_name>/.ssh/known_hosts" -R "[host_address_here]"
