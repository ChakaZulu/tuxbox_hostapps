typedef enum CVCRStates 
    {
    CMD_VCR_UNKNOWN     = 0,
    CMD_VCR_RECORD      = 1,
    CMD_VCR_STOP        = 2,
    CMD_VCR_PAUSE       = 3,
    CMD_VCR_RESUME      = 4,
    CMD_VCR_AVAILABLE   = 5
    }CVCRCommand;

enum CVCRDevices
    {
    DEVICE_VCR,
    DEVICE_SERVER
    };

typedef struct 
    {    
    int cmd; 
    int onidsid;
    int apid;
    int vpid;
    char    channelname[264];
    } RecordingData;
