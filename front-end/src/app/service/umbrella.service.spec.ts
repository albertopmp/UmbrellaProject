import { TestBed } from '@angular/core/testing';

import { UmbrellaService } from './umbrella.service';

describe('UmbrellaService', () => {
  let service: UmbrellaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(UmbrellaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});