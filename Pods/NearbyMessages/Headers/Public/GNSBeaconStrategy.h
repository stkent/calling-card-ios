/// Optional params for a beacon strategy. See properties with the same names in GNSBeaconStrategy.
@interface GNSBeaconStrategyParams : NSObject
@property(nonatomic) BOOL includeIBeacons;
@end

/// The strategy to use to scan for beacons.
@interface GNSBeaconStrategy : NSObject

/// Scan also for nearby iBeacons.
///
/// The default is @c YES. Scanning for iBeacons triggers a location permission dialog from iOS, so
/// you should set this to @c NO if you don't want to scan for iBeacons.
@property(nonatomic, readonly) BOOL includeIBeacons;

/// Returns a custom strategy.  You can set any of the optional properties in @c paramsBlock.
+ (instancetype)strategyWithParamsBlock:(void (^)(GNSBeaconStrategyParams *))paramsBlock;

@end
