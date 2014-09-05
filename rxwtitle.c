/*
 *  Changing title of window
 */
#define  INCL_WINSWITCHLIST
#define  MAXTITLEL 120
#include <os2emx.h>
#include <string.h>
#include <process.h>
#include <sys/types.h>

extern void os2title(int init, const char *mess);

void os2title(int init, const char *mess)
{
  static char new_title[MAXTITLEL];
  static HSWITCH hswitch;
  static SWCNTRL sw;
  static PSWCNTRL psw = (PSWCNTRL) &sw;
  switch(init) {
    case 1:
      /* save current process title */
      hswitch = WinQuerySwitchHandle(0, getpid());
      WinQuerySwitchEntry(hswitch, psw);
      if(psw->uchVisibility) {
        printf( "%s \n", psw->szSwtitle);
      }
      break;
    case 0:
      /* show current status in title */
      if(psw->uchVisibility && mess != NULL && *mess) {
        strncpy(new_title, mess, MAXTITLEL-8-15);
        sprintf(psw->szSwtitle, "%s", new_title);
        WinChangeSwitchEntry(hswitch, psw);
      }
      break;
  }
}

int main(int argc, char *argv[])
{
  os2title(1, NULL);
  if (argc > 1)
  {
    os2title(0, argv[1]);
  }
}
