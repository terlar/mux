================================================================================
MUX
================================================================================

A tmux session wrapper that makes your daily operations smooth as
coconut butter.

Installation
================================================================================

$::

  git clone git://github.com/terlar/mux.git
  cd mux
  make install

Examples
================================================================================

Learn more about ``mux``::

  $ man mux

To create a session running ``top``::

  $ mux monitor top

To attach a session::

  $ mux monitor

To attach last session::

  mux

To create a detached session::

  $ mux work -d

To create a session running ``vi`` inside working directory ``~``::

  $ mux work -c ~ vi

To create a session with a named window::

  $ mux monitor -n kernel dmesg -w --human
