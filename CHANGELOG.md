## 0.9.0 (July 10, 2019)
  - Update tags to events to follow tendermint 0.32.0 upgrade

## 0.8.0 (March 23, 2019)
  - upgrade ex_abci_proto to 0.8

## 0.7.6 (February 06, 2019)
  - use ex_abci_proto

## 0.7.5 (January 22, 2019)
  - set socket active to once when we are done processing with request

## 0.7.4 (January 22, 2019)
  - reorder vendor proto so that the dependency is clear.

## 0.7.3 (January 14, 2019)
  - Fix ranch warning

## 0.7.1 (January 08, 2019)
  - Update two examples to make sure them compilable

## 0.7.0 (January 07, 2019)
  - group all vendor protos together

## 0.6.1 (December 16, 2018)
  - remove override

## 0.6.0 (December 14, 2018)
  - add grpc support

## 0.5.4 (November 30, 2018)
 . - fix configuration

## 0.5.3  (November 30, 2018)
  - bump ranch version to 1.7

## 0.5.2 (November 30, 2018)
  - fix issue for: https://github.com/tendermint/tendermint/issues/2954

## 0.5.1 (November 07, 2018)
  - make sure the code pass dialyzer

## 0.5.0 (November 05, 2018)
  - upgrade to tendermint 0.26. Fix test cases

## 0.4.4 (October 29, 2018)
  - dummy handle query

## 0.4.3 (October 29, 2018)
  - build common.KVPair under abci namespace

## 0.4.2 (October 25, 2018)
  - we don't really use grpc here so remove it and its dep

## 0.4.1-alpha (October 24, 2018)
  - remove empty file

## 0.4.0-alpha (October 23, 2018)
  - make the simple chain work (cannot resume after ctrl+c)
  - init the simple chain example

## 0.3.2-alpha (October 22, 2018)
  - make the counter app example work
  - hide the port from child_spec

## 0.3.0 (October 21, 2018)

* Support basic message processing
* Add example code (incomplete yet)
* Add varint and message unpack tests

## 0.2.0 (October 20, 2018)

Integrate tendermint abci protobuf with the project.

## 0.1.0 (October 20, 2018)

Init the project
