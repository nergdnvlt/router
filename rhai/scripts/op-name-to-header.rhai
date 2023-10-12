// Module file
// From: https://github.com/apollographql/router/blob/main/examples/op-name-to-header/src/op_name_to_header.rhai
// Demo: Make an anonymous operation and it will log it and add it to the headers

fn process_request(request) {
    print("adding operation name to header");
    // We may not have an operation name, so check if we do
    if request.body.operation_name != () {
        print("no operation in name, adding to header");
        request.headers["x-operation-name"] = request.body.operation_name;
    }
}
