/********************************************************************/
/*                                                                  */
/* RXWTITLE, Version 1.2                                            */
/* Author: Michel SUCH. Email: msuch@free.fr                        */
/*                                                                  */
/* Manipulations of current Vio window title from a rexx program    */
/*                                                                  */
/* It uses the following components:                                */
/* - RXWTITLE.EXE to perform real title changes.                    */
/*                                                                  */
/********************************************************************/

/********************************************************************/
new_title:
procedure

/* This function changes the window title */
/* and returns the previous one */

   titler = find_rxwtitle("RXWTITLE.EXE")
   if titler = '' then return '' /* program rxwtitle.exe not found */

   parse arg title
   title = '"'title'"'

   /* Setup a local queue to avoid conflicts with other process */
   ttqueue = rxqueue('create')
   oldq = rxqueue('set', ttqueue)

   "@"titler title "| rxqueue" ttqueue
   parse pull old_title
   oldq = rxqueue('set', oldq)
   ttqueue = rxqueue('delete', ttqueue)
return old_title /* new_title */


/********************************************************************/
cur_title:
procedure

/* This function returns the curent window title */
   titler = find_rxwtitle("RXWTITLE.EXE")
   if titler = '' then return '' /* program rxwtitle.exe not found */

   /* Setup a local queue to avoid conflicts with other process */
   ttqueue = rxqueue('create')
   oldq = rxqueue('set', ttqueue)

   "@"titler "| rxqueue" ttqueue
   parse pull title
   oldq = rxqueue('set', oldq)
   ttqueue = rxqueue('delete', ttqueue)
return title /* cur_title */


/********************************************************************/
find_rxwtitle:
procedure

   if rxfuncquery('sysloadfuncs') <> 0 then do
      call rxfuncadd 'sysloadfuncs', 'rexxutil', 'sysloadfuncs'
      call sysloadfuncs
   end

   /* First, search in the program's directory */
   parse source . . me .
   pgm = stream(filespec('d', me) || filespec('p', me) || arg(1), 'c', 'query exist')
   if pgm = '' then do /* search in the path environment variable */
      pgm = syssearchpath( 'path', arg(1))
   end
return pgm /* find_rxwtitle */
