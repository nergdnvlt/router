// Tap into any of these hook
// Import your own modules here with
// import file_name as module_name
import "op-name-to-header" as add_opp_to_header;

// Wrap the function pointer with a local function 
// https://rhai.rs/book/language/fn-ptr.html?highlight=Fn#warning--global-namespace-only
fn process_operation_name(request) {
    add_opp_to_header::process_request(request);
}

fn supergraph_service(service) {
    let response_callback = |response| {
        print("Supergraph service: Client response ready to send");
    };

    const request_callback = Fn("process_operation_name");

    service.map_request(request_callback);
    service.map_response(response_callback);
}

//
// Uncomment these hooks below to tap into other extension points
// more info: https://www.apollographql.com/docs/router/customizations/rhai/
//

// fn execution_service(service) {
//     let request_callback = |request| {
//         print("Execution service: GraphQL execution initiated");
//     };

//     let response_callback = |response| {
//         print("Supergraph service: Client response assembled");
//     };

//     service.map_request(request_callback);
//     service.map_response(response_callback);
// }

// // Passed an additional `subgraph` parameter that indicates the subgraph's name
// fn subgraph_service(service, subgraph) {
//     let request_callback = |request| {
//         print(`Subgraph service: Ready to send sub-operation to subgraph ${subgraph}`);
//     };

//     let response_callback = |response| {
//         print(`Subgraph service: Received sub-operation response from subgraph ${subgraph}`);
//     };

//     service.map_request(request_callback);
//     service.map_response(response_callback);
// }
