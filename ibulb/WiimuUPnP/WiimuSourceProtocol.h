//
//  WiimuSourceProtocol.h
//  upnpx
//
//  Created by 赵帅 on 15/4/24.
//  Copyright (c) 2015年 wiimu. All rights reserved.
//

#import "WiimuDefine.h"

// streams
typedef enum
{
    wiimu_stream_airplay = 1,
    wiimu_stream_dlna = 2,
    wiimu_stream_ttpod = 10,
    wiimu_stream_douban = 11,
    wiimu_stream_tunein = 16,
    wiimu_stream_pandora = 21
}WiimuDeviceStreamEnum;



typedef enum
{
    wiimu_quality_low,//64kbps
    wiimu_quality_high,//128kbps
    wiimu_quality_super//320kbps
}wiimu_quality;


typedef enum :NSUInteger {
    nxmly_album_hot,
    nxmly_album_recent,
    nxmly_album_classics
}nxmly_album_result_type;

typedef enum :NSUInteger {
    nxmly_radio_national,
    nxmly_radio_province,
    nxmly_radio_Internet
}nxmly_radio_type;

typedef enum :NSUInteger {
    nxmly_announcers_hot,
    nxmly_announcers_recent,
    nxmly_announcers_fans
}nxmly_announcers_result_type;

typedef enum
{
    nxmly_albums,
    nxmly_zhubos,
    nxmly_tracks
}nxmlySearchtype;

typedef enum{
    wiimusdk_stringType,
    wiimusdk_jsonType,
    wiimusdk_xmlType
} wiimusdk_responseType;

@protocol WiimuSourceProtocol <NSObject>

/**
 *  To see if stream is supported
 *
 *  @param stream See WiimuDeviceStreamEnum
 *
 *  @return See WiimuSupportType
 */
- (WiimuSupportType)supportStream:(WiimuDeviceStreamEnum)stream;

#pragma mark - DOUBAN

/**
 *  Get default online radio play list
 *
 *  @param QueueName Online radio's name.
 *  @param QueueID Info userd to get other
 *  @param QueueType Radio's type
 *  @param QueueLimit Return item's max number
 *  @param QueueAutoInsert Whether the items insert
 *  @return
 statuscode: Status code
 QueueContext: The context return.
 */

- (void)GetQueueOnline:(NSString *)QueueName QueueID:(NSString *)QueueID QueueType:(NSString *)QueueType Queuelimit:(int)Queuelimit QueueAutoInsert:(NSString *)QueueAutoInsert result:(WiimuSDKReturnBlock)resultBlock;


/**
 *  Collect queue.
 *
 *  @param QueueName Queue's name
 *  @param QueueID station id
 *  @param Action  collect/Uncollect
 *
 *  @return
 statuscode: Status code
 */

-(void)SetQueueRecord:(NSString *)QueueName QueueID:(NSString *)QueueID Action:(NSString *)Action result:(WiimuSDKReturnBlock)resultBlock;


/**
 *
 *  Operation with songs inside queue.
 *
 *  @param SongID Song's ID
 *  @param Action like_song/unlike_song/ban_song/unban_song
 *
 *  @return
 statuscode: Status code
 */

-(void)SetSongsRecord:(NSString *)QueueName SongID:(NSString *)SongID Action:(NSString *)Action result:(WiimuSDKReturnBlock)resultBlock;

/**
 *   Register
 *
 *
 *  @param UserName username
 *  @param PassWord password
 *
 *  @return
 *      statuscode: Status code
 *      Result: result
 */
-(void)UserRegister:(NSString *)QueueName UserName:(NSString *)UserName PassWord:(NSString *)PassWord result:(WiimuSDKReturnBlock)resultBlock;

/**
 *   Search
 *
 *  @param QueueName Queue's name
 *  @param SearchKey Key word
 *  @param Queuelimit Return item's max number
 *
 *  @return
 QueueContext: Context return
 */

-(void)SearchQueueOnline:(NSString *)QueueName SearchKey:(NSString *)SearchKey Queuelimit:(int)Queuelimit result:(WiimuSDKReturnBlock)resultBlock;

#pragma mark - TTPod

/**************************************************************************
 Notice:
 1 You must call GetControlDeviceInfo before all these TTPod methods.
 2 If device dosn't support TTPod, then these methods will always
 return statuscode -1.
 ***************************************************************************/

/**
 *  Get rank list.
 *
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodRankList:(WiimuSDKReturnBlock)resultBlock;

/**
 *
 *
 *  @param data dictionary, key data is response string in json.
 */
/**
 *  Get a rank list's song list.
 *
 *  @param rankId      rank id
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodRankDetailList:(id)rankId result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get tag list.
 *
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodTagList:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get a tag list's song list.
 *
 *  @param tagId       tag id
 *  @param page        page number
 *  @param size        page size
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodTagDetailList:(id)tagId pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  TTPod's search interface.
 *
 *  @param searchKey   search key.
 *  @param page        page number
 *  @param size        page size
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)searchTTPodWithKey:(NSString *)searchKey pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  TTPod's album search interface.
 *
 *  @param searchKey   search key.
 *  @param page        page number
 *  @param size        page size
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)searchTTPodAlbumWithKey:(NSString *)searchKey pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  TTPod's playlist search interface.
 *
 *  @param searchKey   search key.
 *  @param page        page number
 *  @param size        page size
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)searchTTPodPlaylistWithKey:(NSString *)searchKey pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  TTPod's search suggest
 *  @param searchKey   search key.
 */
- (void)getTTPodSearchSuggest:(NSString *)key result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get TTPod's singer category list.
 *
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodSingerList:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get a singer category's singer list.
 *
 *  @param singerId    singer id
 *  @param page        page number
 *  @param size        page size
 @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodSingerDetailList:(id)cId pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get a singer's song list.
 *
 *  @param singerName  singer's name
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodSingerSongList:(id)singerId pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 *  Get a singer's picture.
 *
 *  @param singerName  singer's name
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTTPodSingerPic:(NSString *)singerName result:(WiimuSDKReturnBlock)resultBlock;

/**
 * Get singer's album
 *
 * @param singerId    singer id
 *  @param page        page number
 *  @param size        page size
 *
 * @return data
 */
- (void)getTTPodSingerAlbumList:(id)singerId pageNum:(int)page pageSize:(int)size result:(WiimuSDKReturnBlock)resultBlock;

/**
 * Get album's songlist
 *
 * @param albumId     album id
 *
 * @return data
 */
- (void)getTTPodAlbumSongList:(id)albumId result:(WiimuSDKReturnBlock)resultBlock;

#pragma mark - Tunein
/**
 *  Get Tunein's root data.
 *
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getTuneinRootData:(WiimuSDKReturnBlock)resultBlock;


#pragma mark - NewXimalaya
/**
 *  Get all xmly categories.
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYCategoriesListWithblock:(WiimuSDKReturnBlock)block;


/**
 *  Get all lists of an album or sound.
 *  @param CategoryID  category Id
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYTagsListWithCategoryID:(NSString *)CategoryID block:(WiimuSDKReturnBlock)block;


/**
 *  Get a list of the latest albums under a category based on categories and tags.
 *
 *  @param TagName   Tag Name
 *  @param CategoryID  category Id
 *  @param page        page number
 *  @param count       page size
 *  @param xmlyrestype AlbumsList type
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYAlbumsListWithTag:(NSString *)TagName CategoryID:(NSString *)CategoryID Page:(int)page count:(int)count xmlyrestype:(nxmly_album_result_type)type block:(WiimuSDKReturnBlock)block;


/**
 *  According to the album ID to get the album under the sound list.
 *
 *  @param AlbumID   Album ID
 *  @param CategoryID  category Id
 *  @param page        page number
 *  @param count       page size
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYAlbumsBrowseWithAlbumID:(NSString *)AlbumID page:(int)page count:(int)count block:(WiimuSDKReturnBlock)block;


/**
 *  Get all xmly provinces.
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYLiveProvincesWithblock:(WiimuSDKReturnBlock)block;


/**
 *  Get all live radios.
 *
 *  @param provinceCode   province Code
 *  @param page        page number
 *  @param count       page size
 *  @param xmlyradiotype   Province type
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYLiveRadiosWithProvince:(NSString *)provinceCode page:(int)page count:(int)count xmlyradiotype:(nxmly_radio_type)type block:(WiimuSDKReturnBlock)block;


/**
 *  Get all xmly Announcers Categories.
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getXMLYAnnouncersCategoriesWithblock:(WiimuSDKReturnBlock)block;

/**
 *  Get a list of Announcers.
 *
 *  @param vcategoryID   vcategory ID
 *  @param page        page number
 *  @param count       page size
 *  @param xmlyAnnouncerstype   Announcers type
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)getXMLYAnnouncersListWithVcategoryId:(NSString *)vcategoryID page:(int)page count:(int)count xmlyAnnouncerstype:(nxmly_announcers_result_type)type block:(WiimuSDKReturnBlock)block;


/**
 *  Get a list of Announcers List
 *
 *  @param vcategoryID   vcategory ID
 *  @param page        page number
 *  @param count       page size
 *  @param xmlyAnnouncerstype   Announcers type
 *  @return data
 dictionary, key data is response string in json.
 */
-(void)getXMLYByAnnouncersListWithAid:(NSString *)aid page:(int)page count:(int)count block:(WiimuSDKReturnBlock)block;

/**
 *  Get a list of Announcers.
 *
 *  @param searchKey   search Key
 *  @param page        page number
 *  @param size       page size
 *  @param nxmlySearchtype   Search type
 *  @return data
 dictionary, key data is response string in json.
 */
- (void)xmlySearch:(NSString *)searchKey page:(int)page size:(int)size nxmlySearchtype:(nxmlySearchtype)type block:(WiimuSDKReturnBlock)block;

@end
