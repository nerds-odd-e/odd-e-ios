import Foundation
import Moya
import Argo
import SVProgressHUD

class Api {
    private let provider  = MoyaProvider<ApiDefinition>()

    private func request(_ method: ApiDefinition, handler: @escaping (Response)->Void){
        SVProgressHUD.show()
        provider.request(method) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200...299:
                    DispatchQueue.main.async(){
                        SVProgressHUD.dismiss()
                    }
                    handler(response)
                default:
                    DispatchQueue.main.async(){
                        SVProgressHUD.showError(withStatus: "Error")
                    }
                    print("error: \(response.statusCode)")
                }
            case .failure(let error):
                DispatchQueue.main.async(){
                    SVProgressHUD.showError(withStatus: "Error")
                }
                print("failure: \(error)")
            }
        }
    }

    private func mapArray<T:Decodable>(_ response: Response) throws -> [T] where T == T.DecodedType {
        do {
            let JSON = try response.mapJSON()

            let decodedArray:Decoded<[T]>
            guard let array = JSON as? [AnyObject] else {
                throw DecodeError.typeMismatch(expected: "\(T.DecodedType.self)", actual: "\(type(of: JSON))")
            }
            decodedArray = decode(array)

            return try decodedValue(decoded: decodedArray)
        } catch {
            throw error
        }
    }

    private func decodedValue<T>(decoded: Decoded<T>) throws -> T {
        switch decoded {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    func getRooms(_ action: @escaping ([DTO.LiveRoom]) -> Void) {
        request(.getRooms) { [unowned me = self] response in
            do {
                action(try me.mapArray(response))
            } catch {

            }
        }
    }
}
