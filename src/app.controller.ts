import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

@Post()
create(@Body() payload: any) {
return {
  message: 'Accion de crear',
   payload
  };

}

  @Get("saludar")
  getHello(): string {
    return this.appService.getHello();
  }
  
  @Get('products/:productId')
getProduct(@Param('productId') productId: string) {
  return `product ${productId}`;
}
}
