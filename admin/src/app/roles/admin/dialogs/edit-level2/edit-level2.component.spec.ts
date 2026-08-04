import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EditLevel2Component } from './edit-level2.component';

describe('EditLevel2Component', () => {
  let component: EditLevel2Component;
  let fixture: ComponentFixture<EditLevel2Component>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EditLevel2Component ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EditLevel2Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
