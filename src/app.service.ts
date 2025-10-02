import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!' + ' Andrew';
  }
  getProductos(): string {
    return 'Producto 1, Producto 2, Producto 3';
  }
}
