# clique-deploy
QCR deployment materials for Clique via Docker

## Instructions for Use

These Docker materials are meant for deployment on @manthey's demo deployment
infrastructure.  To build a Docker container for a particular deployment:

1. ``cd`` into the appropriate deployment directory.

2. ``docker build --force-rm -t kitware/<deployment-name> .``  This will build
   an appropriate Docker image with the name ``kitware/<deployment-name>``,
which can later be used to invoke the container for management purposes.

3. ``docker run -t -i kitware/<deployment-name> /bin/bash``  If anything goes
   wrong in the last step, this command will drop you into a shell in the Docker
container for the build step that failed.  From this shell, you can try the
failing command manually to see what went wrong, and whether you can find a way
to fix it before updating the Dockerfile and returning to step 2.

3. ``docker run -d --restart=always --name=<deployment-name>-<YYYYMMDD>
   kitware/<deployment-name>``  This will run the named Docker container, using
a label of ``<deployment-name>-<YYYYMMDD>``.  Using the date as a tag will help
you remember when a running container was launched.

4. ``sh ~/update.sh``  This refreshes the list of containers the web
   infrastructure knows of, immediately launching the new application via the
web interface.

5. ``docker ps`` This will show the list of running containers.  To start and
   stop containers, or to manage the Docker images, you can use standard Docker
commands.

## Tips

* To do the bulk of work in the container as a non-root user, it is best to
  first perform all steps that root must take care of, then create a non-root
user with something like ``RUN useradd -c "<description of user>" -m -d
/home/<username> -s /bin/bash <username>``, following up with ``USER
<username>``, ``ENV HOME /home/<username>``, and finally ``WORKDIR
/home/<username>`` to bring you into the new home directory.

* The Docker container machine may have trouble retrieving GitHub sources via
  the ``git://`` protocol.  A command like ``RUN git config --global
url."https://".insteadOf git://`` will unconditionally use HTTPS instead, which
should not present the same problem.

* Remember that as each step concludes, Docker creates an intermediary image
  whose initial file contents are *immutable*.  This means, for instance, if you
wish to clone a GitHub repository, then check out a particular commit hash, you
cannot do so in separate Docker commands.  You must instead use ampersands to
chain together several bash commands.  For example:  ``RUN git clone
https://github.com/Organization/project && cd project && git checkout
<commit-hash> && git reset --hard``
