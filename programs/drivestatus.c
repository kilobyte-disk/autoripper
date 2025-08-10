/*
 * Nice little code snippet:
 * https://www.linuxquestions.org/questions/slackware-14/detect-cd-tray-status-4175450610/
 *
 * CDROM header macros
 * https://github.com/torvalds/linux/blob/master/include/uapi/linux/cdrom.h
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/cdrom.h>

int main(int argc, char **argv)
{
	int cdrom;
	int status = 0;

	if ((cdrom = open(argv[1], O_RDONLY | O_NONBLOCK)) < 0) {
		exit(-1);
	}

	switch (ioctl(cdrom, CDROM_DRIVE_STATUS)) {
		case CDS_NO_INFO:
			status = 0;
			break;
		case CDS_NO_DISC:
			status = 1;
			break;
		case CDS_TRAY_OPEN:
			status = 2;
			break;
		case CDS_DRIVE_NOT_READY:
			status = 3;
			break;
		case CDS_DISC_OK:
			status = 4;
			break;
	}

	close(cdrom);

	printf("%i\n", status);
	exit(status);
}
