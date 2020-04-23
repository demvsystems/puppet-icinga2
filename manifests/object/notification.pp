# @summary
#   Manage Icinga 2 notification objects.
#
# @param [Enum['absent', 'present']] ensure
#   Set to present enables the object, absent disables it.
#
# @param [String] notification_name
#   Set the Icinga 2 name of the notification object.
#
# @param [Optional[String]] host_name
#   The name of the host this notification belongs to.
#
# @param [Optional[String]] service_name
#   The short name of the service this notification belongs to. If omitted, this
#   notification object is treated as host notification.
#
# @param [Optional[Icinga2::CustomAttributes]] vars
#   A dictionary containing custom attributes that are specific to this service,
#   a string to do operations on this dictionary or an array for multiple use
#   of custom attributes.
#
# @param [Optional[Variant[String, Array]]] users
#   A list of user names who should be notified.
#
# @param [Optional[Variant[String, Array]]] user_groups
#   A list of user group names who should be notified.
#
# @param [Optional[Hash]] times
#   A dictionary containing begin and end attributes for the notification.
#
# @param [Optional[String]] command
#   The name of the notification command which should be executed when the
#   notification is triggered.
#
# @param [Optional[Variant[Icinga2::Interval,Pattern[/(host|service)\./]]]] interval
#   The notification interval (in seconds). This interval is used for active
#   notifications.
#
# @param [Optional[String]] period
#   The name of a time period which determines when this notification should be
#   triggered.
#
# @param [Optional[String]] zone
#   The zone this object is a member of.
#
# @param [Optional[Variant[Array, String]]] types
#   A list of type filters when this notification should be triggered.
#
# @param [Optional[Variant[Array, String]]] states
#   A list of state filters when this notification should be triggered.
#
# @param [Boolean] template
#   Set to true creates a template instead of an object.
#
# @param [Variant[Boolean, String]] apply
#   Dispose an apply instead an object if set to 'true'. Value is taken as statement,
#   i.e. 'vhost => config in host.vars.vhosts'.
#
# @param [Variant[Boolean, String]] prefix
#   Set notification_name as prefix in front of 'apply for'. Only effects if apply is a string.
#
# @param [Enum['Host', 'Service']] apply_target
#   An object type on which to target the apply rule. Valid values are `Host` and `Service`.
#
# @param [Array] import
#   Sorted List of templates to include.
#
# @param [Stdlib::Absolutepath] target
#   Destination config file to store in this object. File will be declared the
#   first time.
#
# @param [Variant[String, Integer]] order
#   String or integer to set the position in the target file, sorted alpha numeric.
#
define icinga2::object::notification (
  Stdlib::Absolutepath                                                $target,
  Enum['absent', 'present']                                           $ensure            = present,
  String                                                              $notification_name = $title,
  Optional[String]                                                    $host_name         = undef,
  Optional[String]                                                    $service_name      = undef,
  Optional[Icinga2::CustomAttributes]                                 $vars              = undef,
  Optional[Variant[String, Array]]                                    $users             = undef,
  Optional[Variant[String, Array]]                                    $user_groups       = undef,
  Optional[Hash]                                                      $times             = undef,
  Optional[String]                                                    $command           = undef,
  Optional[Variant[Icinga2::Interval,Pattern[/(host|service)\./]]]    $interval          = undef,
  Optional[String]                                                    $period            = undef,
  Optional[String]                                                    $zone              = undef,
  Optional[Variant[Array, String]]                                    $types             = undef,
  Optional[Variant[Array, String]]                                    $states            = undef,
  Variant[Boolean, String]                                            $apply             = false,
  Variant[Boolean, String]                                            $prefix            = false,
  Enum['Host', 'Service']                                             $apply_target      = 'Host',
  Array                                                               $assign            = [],
  Array                                                               $ignore            = [],
  Array                                                               $import            = [],
  Boolean                                                             $template          = false,
  Variant[String, Integer]                                            $order             = 85,
){

  if $ignore != [] and $assign == [] {
    fail('When attribute ignore is used, assign must be set.')
  }

  # compose attributes
  $attrs = {
    'host_name'    => $host_name,
    'service_name' => $service_name,
    'users'        => $users,
    'user_groups'  => $user_groups,
    'times'        => $times,
    'command'      => $command,
    'interval'     => $interval,
    'period'       => $period,
    'zone'         => $zone,
    'types'        => $types,
    'states'       => $states,
    'vars'         => $vars,
  }

  # create object
  icinga2::object { "icinga2::object::Notification::${title}":
    ensure       => $ensure,
    object_name  => $notification_name,
    object_type  => 'Notification',
    import       => $import,
    template     => $template,
    attrs        => delete_undef_values($attrs),
    attrs_list   => keys($attrs),
    target       => $target,
    order        => $order,
    apply        => $apply,
    prefix       => $prefix,
    apply_target => $apply_target,
    assign       => $assign,
    ignore       => $ignore,
  }

}
