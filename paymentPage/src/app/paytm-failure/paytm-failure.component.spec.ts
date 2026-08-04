import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PaytmFailureComponent } from './paytm-failure.component';

describe('PaytmFailureComponent', () => {
  let component: PaytmFailureComponent;
  let fixture: ComponentFixture<PaytmFailureComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PaytmFailureComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PaytmFailureComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
